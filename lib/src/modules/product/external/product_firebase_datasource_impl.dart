import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/core/exceptions/external_exception.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../../../domain/models/order_model.dart';
import '../../stock/infra/datasources/i_new_stock_datasource.dart';
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
    final result = await productCollection.add(product.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    product.id = result.id;

    await updateProduct(product);
    await _updateCacheDoc();
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await productCollection.doc(product.id).update(product.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));
    _updateStock(product);
    _updateOrder(product);
    _updateCacheDoc();

    return product;
  }

  _updateCacheDoc({DateTime? updatedAt}) async {
    await productCollection
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt ?? DateTime.now()}).onError(
            (error, stackTrace) => throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }

  _updateStock(ProductModel product) async {
    GetIt.I.get<INewStockDatasource>().updateStockFromProduct(product: product);
  }

  _updateOrder(ProductModel product) async {
    final productOnOrderDoc = await productOnOrderCollection
        .doc(product.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    if (productOnOrderDoc.exists) {
      List orderList = productOnOrderDoc.get('orderList');

      for (var o in orderList) {
        final orderSnap = await orderCollection.doc(o).get().onError(
            (error, stackTrace) => throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

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
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var p in snap.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }
}
