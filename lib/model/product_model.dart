import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('products');

  bool isLoading = true;

  void createProduct(ProductData product) {
    isLoading = true;
    firebaseCollection.doc().set(product.toMap());
    isLoading = false;
    notifyListeners();
  }

  void updateProduct(ProductData product) {
    isLoading = true;
    firebaseCollection.doc(product.id).update(product.toMap());
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

  Future<List<ProductData>> getAllEnabledProducts() async {
    isLoading = true;
    List<ProductData> productList = [];
    final snapshot = await firebaseCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get();
    for (DocumentSnapshot e in snapshot.docs) {
      productList.add(ProductData.fromDocSnapshot(e));
    }

    isLoading = false;
    notifyListeners();
    return productList;
  }
}
