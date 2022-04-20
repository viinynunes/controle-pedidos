import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/product_data.dart';

class OrderItemModel extends Model {
  
  final firebaseCollection = FirebaseFirestore.instance.collection('orders');

  static OrderItemModel of(BuildContext context) =>
      ScopedModel.of<OrderItemModel>(context);
  
  Future<void> getOrderItemFromOrder(OrderData order) async {
    List<ProductData> productList = await _getProductList();
    order.orderItemList!.clear();

    final snap = await firebaseCollection.doc(order.id).collection('orderItems').get();

    for(var item in snap.docs){
      order.orderItemList!.add(await _getOrderItem(item, productList));
    }
  }



  _getOrderItem(
      QueryDocumentSnapshot item, List<ProductData> productList) async {
    final pID = item.get('productID');
    late OrderItemData oi;

    final prod = productList.firstWhere((element) => element.id == pID);

    oi = OrderItemData.fromDocSnapshot(item, prod);

    return oi;
  }

  _getProductList() async {
    List<ProductData> productList = [];

    final snap = await FirebaseFirestore.instance.collection('products').get();

    for(var e in snap.docs){
      productList.add(ProductData.fromDocSnapshot(e));
    }

    return productList;
  }
}
