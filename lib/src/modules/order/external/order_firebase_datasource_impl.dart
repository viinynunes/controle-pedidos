import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/order_item_model.dart';
import 'package:controle_pedidos/src/domain/models/order_model.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';

class OrderFirebaseDatasourceImpl implements IOrderDatasource {
  final _orderCollection =
      FirebaseHelper.firebaseCollection.collection('order');

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    order.registrationDate = DateTime(order.registrationDate.year,
        order.registrationDate.month, order.registrationDate.day);

    final snap = await _orderCollection.add({}).catchError((e) =>
        throw FirebaseException(
            plugin: 'CREATE ORDER ERROR', message: e.toString()));

    order.id = snap.id;

    for (var item in order.orderItemList) {
      await _orderCollection
          .doc(order.id)
          .collection('orderItem')
          .doc(item.productId)
          .set(OrderItemModel.fromOrderItem(item: item).toMap())
          .catchError((e) => throw FirebaseException(
              plugin: 'CREATE ORDER ITEM ERROR', message: e.toString()));

      //await create stock
    }

    await _orderCollection.doc(order.id).update(order.toMap());

    return order;
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    List<OrderItemModel> beforeUpdateOrderItemsList = [];

    final beforeOrderItemSnap = await _orderCollection
        .doc(order.id)
        .get()
        .catchError((e) => throw FirebaseException(plugin: ''));

    for (var item in beforeOrderItemSnap.get('orderItemList')) {
      beforeUpdateOrderItemsList.add(OrderItemModel.fromMap(map: item.data()));
    }

    final updateOrderSnap = await _orderCollection
        .doc(order.id)
        .update(order.toMap())
        .catchError((e) => throw FirebaseException(
            plugin: 'UPDATE ORDER ERROR', message: e.toString()));

    for (var item in order.orderItemList) {
      //await add stock
    }

    for (var item in beforeUpdateOrderItemsList) {
      //await remove stock
    }

    return order;
  }

  @override
  Future<bool> disableOrder(OrderModel order) async {
    order.enabled = false;
    await _orderCollection.doc(order.id).update(order.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'DISABLE ORDER ERROR'));

    //await disable stock

    return true;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabled() async {
    List<OrderModel> orderList = [];

    final snap = await _orderCollection
        .where('enabled', isEqualTo: true)
        .orderBy('registrationDate', descending: false)
        .get()
        .catchError((e) => throw FirebaseException(plugin: 'GET ORDER ERROR'));

    for (var o in snap.docs) {
      orderList.add(OrderModel.fromMap(map: o.data()));
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledAndDate(DateTime date) async {
    List<OrderModel> orderList = [];

    date = DateTime(date.year, date.month, date.day);

    final snap = await _orderCollection
        .where('enabled', isEqualTo: true)
        .where('registrationDate', isEqualTo: date)
        .orderBy('registrationDate', descending: false)
        .get()
        .catchError((e) => throw FirebaseException(plugin: 'GET ORDER ERROR'));

    for (var o in snap.docs) {
      orderList.add(OrderModel.fromMap(map: o.data()));
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    List<OrderModel> orderList = [];

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snap = await _orderCollection
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .orderBy('registrationDate', descending: false)
        .get()
        .catchError((e) => throw FirebaseException(plugin: 'GET ORDER ERROR'));

    for (var o in snap.docs) {
      orderList.add(OrderModel.fromMap(map: o.data()));
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledAndProduct(
      ProductModel product) async {
    List<OrderModel> orderList = [];

    final snap = await _orderCollection
        .where('orderItemList', arrayContains: product)
        .get()
        .catchError((e) => throw FirebaseException(plugin: 'GET ORDER ERROR'));

    for (var o in snap.docs) {
      orderList.add(OrderModel.fromMap(map: o.data()));
    }

    return orderList;
  }
}
