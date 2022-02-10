import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('orders');

  bool isLoading = false;

  static OrderModel of(BuildContext context) => ScopedModel.of<OrderModel>(context);

  void createOrder(OrderData order) async {
    isLoading = true;
    var x = await firebaseCollection.add(order.toMap());
    order.id = x.id;
    for (var e in order.orderItemList){
      firebaseCollection.doc(order.id).collection('orderItems').doc().set(e.toMap());
    }
    isLoading = false;
    notifyListeners();
  }

  void updateOrder(OrderData order){
    isLoading = true;
    firebaseCollection.doc(order.id).update(order.toMap());
    isLoading = false;
    notifyListeners();
  }

  void disableOrder(OrderData order){
    isLoading = true;
    order.enabled = false;
    firebaseCollection.doc(order.id).update(order.toMap());
    isLoading = false;
    notifyListeners();
  }

  Future<List<OrderData>> getAllEnabledOrders() async {
    isLoading = true;
    List<OrderData> orderList = [];
    final snapshot = await firebaseCollection.where('enabled', isEqualTo: true).orderBy('creationDate', descending: true).get();
    for (var e in snapshot.docs){
      orderList.add(OrderData.fromDocSnapshot(e));
    }

    isLoading = false;
    notifyListeners();
    return orderList;
  }
}