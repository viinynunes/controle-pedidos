import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/order_item_model.dart';
import 'package:controle_pedidos/src/domain/models/order_model.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/firebase_helper_impl.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:controle_pedidos/src/modules/stock/infra/datasources/i_stock_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';

import '../../../domain/entities/order_item.dart';

const cacheDocument = '00_cacheUpdated';

class OrderFirebaseDatasourceImpl implements IOrderDatasource {
  final firebase = FirebaseHelperImpl();

  final IStockDatasource _stockDatasource;

  OrderFirebaseDatasourceImpl(this._stockDatasource);

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    order.registrationDate = DateTime(order.registrationDate.year,
        order.registrationDate.month, order.registrationDate.day);

    final snap = await firebase
        .getOrderCollection()
        .add(order.toMap())
        .catchError((e) => throw FirebaseException(
            plugin: 'CREATE ORDER ERROR', message: e.toString()));

    order.id = snap.id;

    for (var item in order.orderItemList) {
      _createStock(item: item, registrationHour: order.registrationHour);

      _createProductReferenceToOrder(item: item, orderID: order.id);
    }

    await firebase.getOrderCollection().doc(order.id).update(order.toMap());
    await _updateCacheDoc(DateTime.now());

    return order;
  }

  _createStock({required OrderItem item, required DateTime registrationHour}) {
    _stockDatasource.createStock(StockModel(
        id: '0',
        total: item.quantity,
        totalOrdered: 0,
        registrationDate: registrationHour,
        product: item.product));
  }

  _createProductReferenceToOrder(
      {required OrderItem item, required String orderID}) async {
    final pRef =
        await firebase.getProductOnOrderCollection().doc(item.productId).get();

    List orderList = [];

    if (pRef.exists) {
      orderList = pRef.get('orderList');
    }

    orderList.add(orderID);

    await firebase
        .getProductOnOrderCollection()
        .doc(item.productId)
        .set({'orderList': orderList}).catchError((e) =>
            throw FirebaseException(
                plugin: 'CREATE PRODUCT REFERENCE TO ORDER ERROR',
                message: e.toString()));
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    List<OrderItemModel> beforeUpdateOrderItemsList = [];

    final outdatedOrder = await firebase
        .getOrderCollection()
        .doc(order.id)
        .get()
        .catchError((e) => throw FirebaseException(
            plugin: 'GET OUTDATED ORDER ERROR', message: e.toString()));

    for (var item in outdatedOrder.get('orderItemList')) {
      beforeUpdateOrderItemsList.add(OrderItemModel.fromMap(map: item));
    }

    await firebase
        .getOrderCollection()
        .doc(order.id)
        .update(order.toMap())
        .catchError((e) => throw FirebaseException(
            plugin: 'UPDATE ORDER ERROR', message: e.toString()));

    for (var item in order.orderItemList) {
      await _stockDatasource.createStock(StockModel(
          id: '0',
          total: item.quantity,
          totalOrdered: 0,
          registrationDate: order.registrationHour,
          product: item.product));
    }

    for (var item in beforeUpdateOrderItemsList) {
      await _stockDatasource.decreaseStock(
          StockModel(
              id: '0',
              total: item.quantity,
              totalOrdered: 0,
              registrationDate: order.registrationHour,
              product: item.product),
          true);
    }

    await _updateCacheDoc(DateTime.now());
    return order;
  }

  _updateCacheDoc(DateTime updatedAt) async {
    await firebase
        .getProductCollection()
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt});
  }

  @override
  Future<bool> disableOrder(OrderModel order) async {
    order.enabled = false;
    await firebase
        .getOrderCollection()
        .doc(order.id)
        .update(order.toMap())
        .catchError((e) => throw FirebaseException(
            plugin: 'DISABLE ORDER ERROR', message: e.toString()));

    for (var item in order.orderItemList) {
      await _stockDatasource.decreaseStock(
          StockModel(
              id: '0',
              total: item.quantity,
              totalOrdered: 0,
              registrationDate: order.registrationHour,
              product: item.product),
          true);
    }

    await _updateCacheDoc(DateTime.now());

    return true;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabled() async {
    List<OrderModel> orderList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = firebase.getOrderCollection().doc(cacheDocument);

    final query = firebase
        .getOrderCollection()
        .where('enabled', isEqualTo: true)
        .where('enabled', isEqualTo: true)
        .orderBy('registrationDate', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ORDER ERROR', message: e.toString()));

    for (var o in snap.docs) {
      orderList.add(
        OrderModel.fromMap(
            map: o.data(), orderItemList: _getOrderItemList(o.data())),
      );
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledAndDate(DateTime date) async {
    List<OrderModel> orderList = [];

    date = DateTime(date.year, date.month, date.day);

    const cacheField = 'updatedAt';
    final cacheDocRef = firebase.getOrderCollection().doc(cacheDocument);

    final query = firebase
        .getOrderCollection()
        .where('enabled', isEqualTo: true)
        .where('registrationDate', isEqualTo: date)
        .orderBy('registrationHour', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ORDER ERROR', message: e.toString()));

    for (var o in snap.docs) {
      orderList.add(
        OrderModel.fromMap(
            map: o.data(), orderItemList: _getOrderItemList(o.data())),
      );
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    List<OrderModel> orderList = [];

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    const cacheField = 'updatedAt';
    final cacheDocRef = firebase.getOrderCollection().doc(cacheDocument);

    final query = firebase
        .getOrderCollection()
        .where('enabled', isEqualTo: true)
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .orderBy('registrationDate', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ORDER ERROR', message: e.toString()));

    for (var o in snap.docs) {
      orderList.add(
        OrderModel.fromMap(
            map: o.data(), orderItemList: _getOrderItemList(o.data())),
      );
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledAndProductAndDate(
      ProductModel product, DateTime iniDate, DateTime endDate) async {
    List<OrderModel> orderList = [];

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snap = await firebase
        .getOrderCollection()
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .where('enabled', isEqualTo: true)
        .get()
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ORDER ERROR', message: e.toString()));

    for (var o in snap.docs) {
      orderList.add(
        OrderModel.fromMap(
            map: o.data(), orderItemList: _getOrderItemList(o.data())),
      );
    }
    final oi = OrderItemModel(
        listIndex: 0,
        productId: product.id,
        quantity: 0,
        product: product,
        note: '');

    orderList.removeWhere((order) => !order.orderItemList.contains(oi));

    for (var o in orderList) {
      o.orderItemList.removeWhere((element) => element != oi);

      if (o.orderItemList.length != 1) {
        throw Exception('Erro ao remover order items from list');
      }
    }

    return orderList;
  }

  _getOrderItemList(Map<String, dynamic> map) {
    List<OrderItemModel> itemList = [];

    for (var e in map['orderItemList']) {
      itemList.add(OrderItemModel.fromMap(map: e));
    }

    return itemList;
  }
}
