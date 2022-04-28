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

  List<StockData> stockListAll = [];
  List<ProviderData> providerListAll = [];
  DateTime iniDateAll = DateTime.now();
  DateTime endDateAll = DateTime.now();

  static StockModel of(BuildContext context) =>
      ScopedModel.of<StockModel>(context);

  Future<StockData> createStockItem(
      StockData newStock, VoidCallback onError) async {
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
              .update(stockIndex.toMap())
              .then((value) => alreadyInStock = true)
              .catchError((e) {
            onError();
          });
          break;
        }
      }
      if (alreadyInStock == false) {
        await firebaseCollection
            .add(newStock.toMap())
            .then((recStock) => newStock.id = recStock.id)
            .catchError((e) {
          onError();
        });
      }
    } else {
      await firebaseCollection
          .add(newStock.toMap())
          .then((recStock) => newStock.id = recStock.id)
          .catchError((e) {
        onError();
      });
    }

    return newStock;
  }

  Future<StockData> createDuplicatedStockItem(StockData newStock) async {
    newStock.creationDate = DateTime(newStock.creationDate.year,
        newStock.creationDate.month, newStock.creationDate.day);

    final snap = await firebaseCollection
        .where('creationDate', isEqualTo: newStock.creationDate)
        .get();

    if (snap.docs.isNotEmpty) {
      for (var snapIndex in snap.docs) {
        var snapItem = StockData.fromMap(snapIndex.id, snapIndex.data());

        if (snapItem.product.id == newStock.product.id) {
          if (snapItem.product.provider != newStock.product.provider) {
            firebaseCollection
                .add(newStock.toMap())
                .then((value) => newStock.id = value.id);
          }
        }
      }
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
      OrderData orderNew,
      List<OrderItemData> orderItemsDB,
      VoidCallback onSuccess,
      VoidCallback onError) async {
    loading = true;

    try {
      for (var e in orderNew.orderItemList!) {
        if (!orderItemsDB.contains(e)) {
          StockData newStock =
              StockData(e.quantity, 0, orderNew.creationDate, e.product);
          await createStockItem(newStock, () {});
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
      onSuccess();
    } catch (e) {
      onError();
    }
  }

  Future<void> deleteFromOrder(OrderData order) async {
    for (var orderItem in order.orderItemList!) {
      final snapshot = await firebaseCollection
          .where('creationDate', isEqualTo: order.creationDate)
          .where('product.id', isEqualTo: orderItem.product.id)
          .get();

      DocumentSnapshot docToUpdate = snapshot.docs.first;

      StockData stockItem = StockData.fromMap(
          docToUpdate.id, docToUpdate.data() as Map<String, dynamic>);

      stockItem.total = stockItem.total - orderItem.quantity;

      if (stockItem.total == 0 && stockItem.totalOrdered == 0) {
        await docToUpdate.reference.delete();
      } else {
        await firebaseCollection.doc(stockItem.id).update(stockItem.toMap());
      }
    }
  }

  Future<void> deleteStock(StockData stock) async {
    final snap = await firebaseCollection
        .where('creationDate', isEqualTo: stock.creationDate)
        .where('product.id', isEqualTo: stock.product.id)
        .get();

    DocumentSnapshot stockItem = snap.docs.first;

    await stockItem.reference.delete();
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

    providerListAll.addAll(providerList);
    iniDateAll = iniDate;
    endDateAll = endDate;

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

    stockListAll.addAll(stockUniqueList);
    iniDateAll = iniDate;
    endDateAll = endDate;

    loading = false;
    notifyListeners();

    return stockUniqueList;
  }

  Future<List<StockData>> getStockBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    List<StockData> stockList = [];

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final stockSnap = await firebaseCollection
        .where('creationDate', isGreaterThanOrEqualTo: iniDate)
        .where('creationDate', isLessThanOrEqualTo: endDate)
        .get();

    for (var e in stockSnap.docs) {
      stockList.add(StockData.fromMap(e.id, e.data()));
    }

    return stockList;
  }
}
