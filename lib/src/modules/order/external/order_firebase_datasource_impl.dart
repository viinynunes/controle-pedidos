import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/order_item_model.dart';
import 'package:controle_pedidos/src/domain/models/order_model.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_storage/get_storage.dart';

import '../../../domain/entities/order_item.dart';

const cacheDocument = '00_cacheUpdated';

class OrderFirebaseDatasourceImpl implements IOrderDatasource {
  final FirebaseFirestore firebase;

  late CollectionReference<Map<String, dynamic>> orderCollection;
  late CollectionReference<Map<String, dynamic>> productOnOrderCollection;

  OrderFirebaseDatasourceImpl({required this.firebase, String? companyID}) {
    orderCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('order');

    productOnOrderCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('productOnOrder');
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final snap = await orderCollection.add(order.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'CREATE ORDER ERROR', message: e.toString()));

    order.id = snap.id;

    for (var item in order.orderItemList) {
      _createProductReferenceToOrder(item: item, orderID: order.id);
    }

    return order;
  }

  _createProductReferenceToOrder(
      {required OrderItem item, required String orderID}) async {
    final pRef = await productOnOrderCollection.doc(item.product.id).get();

    List orderList = [];

    if (pRef.exists) {
      orderList = pRef.get('orderList');
    }

    orderList.add(orderID);

    await productOnOrderCollection
        .doc(item.product.id)
        .set({'orderList': orderList}).catchError((e) =>
            throw FirebaseException(
                plugin: 'CREATE PRODUCT REFERENCE TO ORDER ERROR',
                message: e.toString()));
  }

  _removeProductReferenceFromOrder(
      {required OrderItem item, required String orderID}) async {
    final pRef = await productOnOrderCollection.doc(item.product.id).get();

    var orderList = pRef.get('orderList');

    orderList.remove(orderID);

    await productOnOrderCollection
        .doc(item.product.id)
        .set({'orderList': orderList}).catchError((e) =>
            throw FirebaseException(
                plugin: 'CREATE PRODUCT REFERENCE TO ORDER ERROR',
                message: e.toString()));
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    List<OrderItemModel> beforeUpdateOrderItemsList = [];

    final orderOnDBRef = await orderCollection.doc(order.id).get().catchError(
        (e) => throw FirebaseException(
            plugin: 'GET ORDER BY ID ERROR', message: e.toString()));

    for (var item in orderOnDBRef.get('orderItemList')) {
      beforeUpdateOrderItemsList.add(OrderItemModel.fromMap(map: item));
    }

    await orderCollection.doc(order.id).update(order.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'UPDATE ORDER ERROR', message: e.toString()));

    for (var item in beforeUpdateOrderItemsList) {
      await _removeProductReferenceFromOrder(item: item, orderID: order.id);
    }

    for (var item in order.orderItemList) {
      await _createProductReferenceToOrder(item: item, orderID: order.id);
    }

    await _updateCacheDoc(DateTime.now());
    return order;
  }

  _updateCacheDoc(DateTime updatedAt) async {
    await orderCollection.doc(cacheDocument).set({'updatedAt': updatedAt});
  }

  @override
  Future<bool> disableOrder(OrderModel order) async {
    order.enabled = false;
    await orderCollection.doc(order.id).update(order.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'DISABLE ORDER ERROR', message: e.toString()));

    for (var item in order.orderItemList) {
      await _removeProductReferenceFromOrder(item: item, orderID: order.id);
    }

    await _updateCacheDoc(DateTime.now());

    return true;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabled() async {
    List<OrderModel> orderList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = orderCollection.doc(cacheDocument);

    final query = orderCollection
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
      orderList.add(OrderModel.fromDocumentSnapshot(doc: o));
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledAndDate(DateTime date) async {
    List<OrderModel> orderList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = orderCollection.doc(cacheDocument);

    final query = orderCollection
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
      orderList.add(OrderModel.fromDocumentSnapshot(doc: o));
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    List<OrderModel> orderList = [];

    final snap = await orderCollection
        .where('enabled', isEqualTo: true)
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .get(const GetOptions(source: Source.cache))
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ORDER ERROR', message: e.toString()));

    for (var o in snap.docs) {
      orderList.add(OrderModel.fromDocumentSnapshot(doc: o));
    }

    return orderList;
  }

  @override
  Future<List<OrderModel>> getOrderListByEnabledAndProductAndDate(
      ProductModel product, DateTime iniDate, DateTime endDate) async {
    List<OrderModel> orderList = [];

    final snap = await orderCollection
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .where('enabled', isEqualTo: true)
        .get()
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ORDER ERROR', message: e.toString()));

    for (var o in snap.docs) {
      orderList.add(OrderModel.fromDocumentSnapshot(doc: o));
    }
    final oi =
        OrderItemModel(listIndex: 0, quantity: 0, product: product, note: '');

    orderList.removeWhere((order) => !order.orderItemList.contains(oi));

    for (var o in orderList) {
      o.orderItemList.removeWhere((element) => element != oi);

      if (o.orderItemList.length != 1) {
        throw Exception('Erro ao remover order items from list');
      }
    }

    return orderList;
  }
}
