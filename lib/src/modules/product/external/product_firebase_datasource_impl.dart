import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';

import '../infra/datasources/i_product_datasource.dart';

class ProductFirebaseDatasourceImpl implements IProductDatasource {
  final _productCollection =
      FirebaseHelper.firebaseCollection.collection('product');

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final result = await _productCollection.add({}).catchError(
        (e) => throw FirebaseException(plugin: 'CREATE PRODUCT ERROR'));

    product.id = result.id;

    return await updateProduct(product);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await _productCollection.doc(product.id).update(product.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'UPDATE PRODUCT ERROR'));

    return product;
  }

  @override
  Future<List<ProductModel>> getEnabledProductListByProvider(
      String providerId) async {
    List<ProductModel> productList = [];

    final snap = await _productCollection
        .where('enabled', isEqualTo: true)
        .where('providerId', isEqualTo: providerId)
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

    final snap =
        await _productCollection.orderBy('name', descending: false).get();

    for (var p in snap.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  @override
  Future<List<ProductModel>> getProductListByEnabled() async {
    List<ProductModel> productList = [];

    final snap = await _productCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get();

    for (var p in snap.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  @override
  Future<List<ProductModel>>
      getProductListByEnabledAndStockDefaultTrue() async {
    List<ProductModel> productList = [];

    final snapshot = await _productCollection
        .where('enabled', isEqualTo: true)
        .where('stockDefault', isEqualTo: true)
        .get();

    for (var p in snapshot.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  void moveToV2() async {
    final snap = await FirebaseFirestore.instance.collection('products').get();

    for (var p in snap.docs) {
      _productCollection
          .doc(p.id)
          .set(ProductModel.fromMap(map: p.data()).toMap());
    }
  }
}
