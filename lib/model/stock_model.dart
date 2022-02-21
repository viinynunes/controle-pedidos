import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class StockModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('stock');
  bool loading = false;

  static StockModel of(BuildContext context) =>
      ScopedModel.of<StockModel>(context);

  Future<StockData> createStockItem(StockData newStock) async {
    bool alreadyInStock = false;

    newStock.creationDate = DateTime(newStock.creationDate.year,
        newStock.creationDate.month, newStock.creationDate.day);

    final snap = await firebaseCollection
        .where('creationDate', isEqualTo: newStock.creationDate)
        .get();

    if (snap.docs.isNotEmpty) {
      for (var e in snap.docs) {
        alreadyInStock = false;
        var stockIndex = StockData.fromMap(e.id, e.data());

        if (stockIndex.product.id == newStock.product.id) {
          stockIndex.total += newStock.total;
          await firebaseCollection
              .doc(stockIndex.id)
              .update(stockIndex.toMap());
          alreadyInStock = true;
          break;
        }
      }
      if (alreadyInStock == false) {
        final recStock = await firebaseCollection.add(newStock.toMap());
        newStock.id = recStock.id;
      }
    } else {
      final recStock = await firebaseCollection.add(newStock.toMap());
      newStock.id = recStock.id;
    }

    return newStock;
  }

  Future<void> updateStockItem(StockData stock, VoidCallback onError) async {
    loading = true;
    try {
      await firebaseCollection.doc(stock.id).update(stock.toMap());
    } catch (e) {
      onError();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> updateStockFromOrder(
      OrderData orderNew, List<OrderItemData> orderItemsDB) async {
    loading = true;

    for (var e in orderNew.orderItemList!) {
      if (!orderItemsDB.contains(e)) {
        StockData newStock =
            StockData(e.quantity, 0, orderNew.creationDate, e.product);
        await createStockItem(newStock);
      }
    }

    for (var old in orderItemsDB) {
      if (orderNew.orderItemList!.contains(old)) {
        var newItem = orderNew.orderItemList!
            .singleWhere((element) => element.product.id == old.product.id);

        final snapStock = await firebaseCollection
            .where('creationDate', isEqualTo: orderNew.creationDate)
            .where('product.id', isEqualTo: newItem.product.id)
            .get();

        var stockItem = StockData.fromMap(
            snapStock.docs.first.id, snapStock.docs.first.data());

        if (newItem.quantity > old.quantity) {
          stockItem.total = newItem.quantity + stockItem.total - old.quantity;
          firebaseCollection.doc(stockItem.id).update(stockItem.toMap());
        } else if (newItem.quantity < old.quantity) {
          stockItem.total = stockItem.total - old.quantity + newItem.quantity;
          firebaseCollection.doc(stockItem.id).update(stockItem.toMap());
        }
      } else {
        if (orderItemsDB.contains(old)) {
          final snapCollection = await firebaseCollection
              .where('creationDate', isEqualTo: orderNew.creationDate)
              .where('product.id', isEqualTo: old.product.id)
              .get();

          final DocumentSnapshot snapDelete = snapCollection.docs.first;

          StockData stockItem = StockData.fromMap(
              snapDelete.id, snapDelete.data() as Map<String, dynamic>);

          stockItem.total = stockItem.total - old.quantity;

          if (stockItem.total == 0 && stockItem.totalOrdered == 0) {
            await snapDelete.reference.delete();
          } else {
            await firebaseCollection
                .doc(snapDelete.id)
                .update(stockItem.toMap());
          }
        }
      }
    }
  }

  Future<Set<ProviderData>> getAllStockProvidersByDate(
      DateTime iniDate, DateTime endDate) async {
    Set<ProviderData> providerList = {};
    loading = true;

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snapStock = await firebaseCollection
        .where('creationDate', isGreaterThanOrEqualTo: iniDate)
        .where('creationDate', isLessThanOrEqualTo: endDate)
        .get();

    for (var e in snapStock.docs) {
      var stockIndex = StockData.fromMap(e.id, e.data());

      providerList
          .add(ProviderData.fromMap(stockIndex.product.provider.toMap()));
    }

    loading = false;
    notifyListeners();

    return providerList;
  }

  Future<List<StockData>> getAllStocksByDateAndProvider(
      DateTime iniDate, DateTime endDate, ProviderData provider) async {
    List<StockData> stockUniqueList = [];
    List<StockData> stockAllList = [];
    loading = true;

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snapStock = await firebaseCollection
        .where('product.provider.id', isEqualTo: provider.id)
        .where('creationDate', isGreaterThanOrEqualTo: iniDate)
        .where('creationDate', isLessThanOrEqualTo: endDate)
        .get();

    for (var e in snapStock.docs) {
      stockAllList.add(StockData.fromMap(e.id, e.data()));
    }

    stockAllList.sort((a, b) =>
        a.product.name.toLowerCase().compareTo(b.product.name.toLowerCase()));
    StockData? lastStock;
    for (var stockIndex in stockAllList) {
      if (lastStock != null && stockIndex.product.id == lastStock.product.id) {
        stockIndex.total += lastStock.total;
        stockIndex.totalOrdered += lastStock.totalOrdered;

        stockUniqueList.remove(lastStock);
        stockUniqueList.add(stockIndex);
      } else {
        stockUniqueList.add(stockIndex);
      }
      lastStock = stockIndex;
    }

    loading = false;
    notifyListeners();

    return stockUniqueList;
  }
}
