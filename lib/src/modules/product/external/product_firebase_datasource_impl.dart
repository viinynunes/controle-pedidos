import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../../../domain/models/order_model.dart';
import '../infra/datasources/i_product_datasource.dart';

const cacheDocument = '00_cacheUpdated';

class ProductFirebaseDatasourceImpl implements IProductDatasource {
  final FirebaseFirestore firebase;

  late CollectionReference<Map<String, dynamic>> productCollection;
  late CollectionReference<Map<String, dynamic>> orderCollection;
  late CollectionReference<Map<String, dynamic>> stockCollection;
  late CollectionReference<Map<String, dynamic>> productOnOrderCollection;

  ProductFirebaseDatasourceImpl({required this.firebase, String? companyID}) {
    productCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('product');

    orderCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('order');

    stockCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('stock');

    productOnOrderCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('productOnOrder');
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final result = await productCollection.add(product.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'CREATE PRODUCT ERROR'));

    product.id = result.id;

    await updateProduct(product);
    await _updateCacheDoc();
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await productCollection.doc(product.id).update(product.toMap());
    _updateStock(product);
    _updateOrder(product);
    await _updateCacheDoc();

    return product;
  }

  _updateCacheDoc({DateTime? updatedAt}) async {
    await productCollection
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt ?? DateTime.now()});
  }

  _updateStock(ProductModel product) async {
    final stockSnap =
        await stockCollection.where('product.id', isEqualTo: product.id).get();

    for (var s in stockSnap.docs) {
      stockCollection.doc(s.id).update({'product': product.toMap()});
    }
  }

  _updateOrder(ProductModel product) async {
    final productOnOrderDoc =
        await productOnOrderCollection.doc(product.id).get();

    if (productOnOrderDoc.exists) {
      List orderList = productOnOrderDoc.get('orderList');

      for (var o in orderList) {
        final orderSnap = await orderCollection.doc(o).get();

        var order = OrderModel.fromDocumentSnapshot(doc: orderSnap);

        var orderItemFromProduct = order.orderItemList
            .singleWhere((element) => element.product.id == product.id);

        orderItemFromProduct.product = product;

        GetIt.I.get<IOrderDatasource>().updateOrder(order);
      }
    }
  }

  @override
  Future<List<ProductModel>> getEnabledProductListByProvider(
      String providerId) async {
    List<ProductModel> productList = [];

    final snap = await productCollection
        .where('enabled', isEqualTo: true)
        .where('provider.id', isEqualTo: providerId)
        .orderBy('name', descending: false)
        .get();

    for (var p in snap.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  @override
  Future<List<ProductModel>> getProductList() async {
    List<ProductModel> productList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = productCollection.doc(cacheDocument);

    final query = productCollection.orderBy('name', descending: false);

    final snapCached = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET PRODUCT ERROR', message: e.toString()));

    for (var p in snapCached.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  @override
  Future<List<ProductModel>> getProductListByEnabled() async {
    List<ProductModel> productList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = productCollection.doc(cacheDocument);

    final query = productCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET PRODUCT ERROR', message: e.toString()));

    for (var p in snap.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  @override
  Future<List<ProductModel>>
      getProductListByEnabledAndStockDefaultTrue() async {
    List<ProductModel> productList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = productCollection.doc(cacheDocument);

    final query = productCollection
        .where('enabled', isEqualTo: true)
        .where('stockDefault', isEqualTo: true);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET PRODUCT ERROR', message: e.toString()));

    for (var p in snap.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  void moveToV2() async {
    final snap = await FirebaseFirestore.instance.collection('products').get();

    for (var p in snap.docs) {
      productCollection
          .doc(p.id)
          .set(ProductModel.fromMap(map: p.data()).toMap());
    }
  }
}
