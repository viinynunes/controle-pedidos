import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/core/exceptions/external_exception.dart';
import 'package:controle_pedidos/src/domain/models/order_item_model.dart';
import 'package:controle_pedidos/src/domain/models/order_model.dart';
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
    final snap = await orderCollection.add(order.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    order.id = snap.id;

    for (var item in order.orderItemList) {
      _createProductReferenceToOrder(item: item, orderID: order.id);
    }

    return order;
  }

  _createProductReferenceToOrder(
      {required OrderItem item, required String orderID}) async {
    final pRef = await productOnOrderCollection
        .doc(item.product.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    List orderList = [];

    if (pRef.exists) {
      orderList = pRef.get('orderList');
    }

    orderList.add(orderID);

    await productOnOrderCollection
        .doc(item.product.id)
        .set({'orderList': orderList}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }

  _removeProductReferenceFromOrder(
      {required OrderItem item, required String orderID}) async {
    final pRef = await productOnOrderCollection
        .doc(item.product.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    var orderList = pRef.get('orderList');

    orderList.remove(orderID);

    await productOnOrderCollection
        .doc(item.product.id)
        .set({'orderList': orderList}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    List<OrderItemModel> beforeUpdateOrderItemsList = [];

    final orderOnDBRef = await orderCollection.doc(order.id).get().onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var item in orderOnDBRef.get('orderItemList')) {
      beforeUpdateOrderItemsList.add(OrderItemModel.fromMap(map: item));
    }

    await orderCollection.doc(order.id).update(order.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
    await orderCollection
        .doc(cacheDocument)
        .set({'updatedAt': updatedAt}).onError((error, stackTrace) =>
            throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }

  @override
  Future<bool> disableOrder(OrderModel order) async {
    await orderCollection.doc(order.id).update(order.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var o in snap.docs) {
      orderList.add(OrderModel.fromDocumentSnapshot(doc: o));
    }

    return orderList;
  }
}
