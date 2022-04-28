import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/order_item_model.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('orders');

  bool isLoading = false;
  List<OrderData> orderListAll = [];
  DateTime orderDate = DateTime.now();

  List<ProductData> productList = [];

  static OrderModel of(BuildContext context) =>
      ScopedModel.of<OrderModel>(context);

  Future<void> createOrder(
      OrderData order, VoidCallback onSuccess, VoidCallback onError) async {
    isLoading = true;

    try {
      order.creationDate = DateTime(order.creationDate.year,
          order.creationDate.month, order.creationDate.day);

      var x = await firebaseCollection.add(order.toResumedMap());
      order.id = x.id;
      for (var e in order.orderItemList!) {
        firebaseCollection
            .doc(order.id)
            .collection('orderItems')
            .doc()
            .set(e.toMap());

        final stock = StockData(e.quantity, 0, DateTime.now(), e.product);
        StockModel().createStockItem(stock, () => onError());
      }
      onSuccess();
    } catch (e) {
      onError();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateOrder(
      OrderData order, VoidCallback onSuccess, VoidCallback onError) async {
    isLoading = true;
    List<OrderItemData> orderItemsDB = [];
    List<ProductData> productList = await _getProductList();

    try {
      firebaseCollection.doc(order.id).update(order.toResumedMap());
      final snap =
          await firebaseCollection.doc(order.id).collection('orderItems').get();
      for (var e in snap.docs) {
        orderItemsDB.add(_getOrderItem(e, productList));
        await e.reference.delete();
      }
      for (var e in order.orderItemList!) {
        firebaseCollection
            .doc(order.id)
            .collection('orderItems')
            .doc()
            .set(e.toMap())
            .catchError((e) => onError());
      }
      StockModel()
          .updateStockFromOrder(order, orderItemsDB, onSuccess, onError);
    } catch (e) {
      onError();
    }

    isLoading = false;
    notifyListeners();
  }

  void disableOrder(OrderData order) async {
    OrderItemModel oiModel = OrderItemModel();
    isLoading = true;
    order.enabled = false;
    if (order.orderItemList!.isEmpty) {
      await oiModel.getOrderItemFromOrder(order);
    }
    StockModel().deleteFromOrder(order);
    firebaseCollection.doc(order.id).update(order.toResumedMap());
    isLoading = false;
    notifyListeners();
  }

  Future<List<OrderData>> getAllEnabledOrders() async {
    isLoading = true;
    List<OrderData> orderList = [];
    final orderSnap = await firebaseCollection
        .where('enabled', isEqualTo: true)
        .orderBy('creationDate', descending: true)
        .get();

    for (var e in orderSnap.docs) {
      OrderData order = OrderData.fromDocSnapshot(e);
      final orderItemSnap =
          await firebaseCollection.doc(order.id).collection('orderItems').get();

      for (var e in orderItemSnap.docs) {
        order.orderItemList!
            .add(await _getOrderItem(e, await _getProductList()));
      }
      orderList.add(order);
    }

    isLoading = false;
    notifyListeners();
    return orderList;
  }

  Future<List<OrderData>> getEnabledOrderFromDate(DateTime date) async {
    isLoading = true;
    List<OrderData> orderList = [];
    var formDate = DateTime(date.year, date.month, date.day);

    final orderSnap = await firebaseCollection
        .where('enabled', isEqualTo: true)
        .where('creationDate', isEqualTo: formDate)
        .get();

    for (var o in orderSnap.docs) {
      orderList.add(OrderData.fromDocSnapshot(o));
    }

    orderListAll.clear();
    orderListAll.addAll(orderList);
    orderDate = date;

    isLoading = false;
    notifyListeners();

    return orderList;
  }

  Future<List<OrderData>> getEnabledOrdersBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    isLoading = true;
    List<OrderData> orderList = [];
    List<ProductData> productList = await _getProductList();
    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);
    final orderSnap = await firebaseCollection
        .where('enabled', isEqualTo: true)
        .where('creationDate', isGreaterThanOrEqualTo: iniDate)
        .where('creationDate', isLessThanOrEqualTo: endDate)
        .get();

    for (var e in orderSnap.docs) {
      OrderData order = OrderData.fromDocSnapshot(e);
      final orderItemSnap =
          await firebaseCollection.doc(order.id).collection('orderItems').get();

      for (var e in orderItemSnap.docs) {
        order.orderItemList!.add(await _getOrderItem(e, productList));
      }
      orderList.add(order);
    }

    orderList.sort((a, b) =>
        a.client.name.toLowerCase().compareTo(b.client.name.toLowerCase()));

    isLoading = false;
    notifyListeners();
    return orderList;
  }

  Future<List<OrderData>> getOrderListByProduct(
      ProductData product, DateTime iniDate, DateTime endDate) async {
    List<OrderData> orderList = [];
    List<ProductData> productList = await _getProductList();

    final snapOrder = await firebaseCollection
        .where('enabled', isEqualTo: true)
        .where('creationDate', isGreaterThanOrEqualTo: iniDate)
        .where('creationDate', isLessThanOrEqualTo: endDate)
        .get();

    for (var docSnapOrder in snapOrder.docs) {
      final orderIndex = OrderData.fromDocSnapshot(docSnapOrder);

      final orderItemSnap = await firebaseCollection
          .doc(orderIndex.id)
          .collection('orderItems')
          .where('productID', isEqualTo: product.id)
          .get();

      if (orderItemSnap.docs.isNotEmpty) {
        final orderItemData =
            await _getOrderItem(orderItemSnap.docs.first, productList);
        orderIndex.orderItemList!.add(orderItemData);
        orderList.add(orderIndex);
      }
    }

    return orderList;
  }

  _getOrderItem(QueryDocumentSnapshot item, List<ProductData> productList) {
    final pID = item.get('productID');
    late OrderItemData oi;

    final prod = productList.firstWhere((element) => element.id == pID);

    oi = OrderItemData.fromDocSnapshot(item, prod);

    return oi;
  }

  _getProductList() async {
    List<ProductData> productList = [];

    final snap = await FirebaseFirestore.instance.collection('products').get();

    for (var e in snap.docs) {
      productList.add(ProductData.fromDocSnapshot(e));
    }

    return productList;
  }
}
