import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('products');

  bool isLoading = false;
  List<ProductData> productList = [];

  static ProductModel of(BuildContext context) =>
      ScopedModel.of<ProductModel>(context);

  Future<ProductData> createProduct(ProductData product) async {
    isLoading = true;
    firebaseCollection
        .add(product.toMap())
        .then((value) => product.id = value.id);
    isLoading = false;
    notifyListeners();

    return product;
  }

  Future<void> updateProduct(ProductData product) async {
    isLoading = true;
    await firebaseCollection.doc(product.id).update(product.toMap());
    isLoading = false;
    notifyListeners();
  }

  void disableProduct(ProductData product) {
    isLoading = true;
    product.enabled = false;
    firebaseCollection.doc(product.id).update(product.toMap());
    isLoading = false;
    notifyListeners();
  }

  Future<List<ProductData>> getFilteredEnabledProducts({String? search}) async {
    isLoading = true;
    List<ProductData> auxList = [];
    final snapshot = await firebaseCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get();
    if (search != null) {
      for (DocumentSnapshot e in snapshot.docs) {
        String name = e.get('name');
        if (name.toLowerCase().contains(search.toLowerCase())) {
          auxList.add(ProductData.fromDocSnapshot(e));
        }
      }
    } else {
      for (DocumentSnapshot e in snapshot.docs) {
        auxList.add(ProductData.fromDocSnapshot(e));
      }
    }
    productList.clear();
    productList.addAll(auxList);

    isLoading = false;
    notifyListeners();
    return auxList;
  }

  Future<List<ProductData>> getEnabledProductsFromProvider(
      {required ProviderData provider}) async {
    isLoading = true;
    List<ProductData> productList = [];

    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('enabled', isEqualTo: true)
        .where('provider.id', isEqualTo: provider.id)
        .orderBy('name', descending: false)
        .get();

    for (var e in snapshot.docs) {
      productList.add(ProductData.fromDocSnapshot(e));
    }

    isLoading = false;
    notifyListeners();
    return productList;
  }

  Future<List<ProductData>> getEnabledProductsByStockDefaultTrue() async {
    List<ProductData> productList = [];

    final snapshot =
        await firebaseCollection.where('stockDefault', isEqualTo: true).get();

    for (var e in snapshot.docs) {
      productList.add(ProductData.fromDocSnapshot(e));
    }

    return productList;
  }
}
