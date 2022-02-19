import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('orders');

  bool isLoading = false;

  static OrderModel of(BuildContext context) =>
      ScopedModel.of<OrderModel>(context);

  Future<void> createOrder(OrderData order) async {
    isLoading = true;
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

      final stock = StockData(e.quantity, e.quantity, DateTime.now(), e.product);
      await StockModel().createStockItem(stock);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateOrder(OrderData order) async {
    isLoading = true;
    final snap =
        await firebaseCollection.doc(order.id).collection('orderItems').get();
    for (DocumentSnapshot e in snap.docs) {
      await e.reference.delete();
    }
    for (var e in order.orderItemList!) {
      await firebaseCollection
          .doc(order.id)
          .collection('orderItems')
          .doc()
          .set(e.toMap());
    }
    isLoading = false;
    notifyListeners();
  }

  void disableOrder(OrderData order) {
    isLoading = true;
    order.enabled = false;
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
        order.orderItemList!.add(OrderItemData.fromDocSnapshot(e));
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

    for (var e in orderSnap.docs) {
      OrderData order = OrderData.fromDocSnapshot(e);
      final orderItemSnap =
          await firebaseCollection.doc(order.id).collection('orderItems').get();

      for (var e in orderItemSnap.docs) {
        order.orderItemList!.add(OrderItemData.fromDocSnapshot(e));
      }
      orderList.add(order);
    }

    isLoading = false;
    notifyListeners();
    return orderList;
  }

  Future<List<OrderData>> getEnabledOrdersBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    isLoading = true;
    List<OrderData> orderList = [];
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
        order.orderItemList!.add(OrderItemData.fromDocSnapshot(e));
      }
      orderList.add(order);
    }

    isLoading = false;
    notifyListeners();
    return orderList;
  }
}
