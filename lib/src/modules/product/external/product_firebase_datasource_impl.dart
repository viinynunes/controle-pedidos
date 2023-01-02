import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/order_item_model.dart';
import '../../../domain/models/order_model.dart';
import '../../firebase_helper_impl.dart';
import '../infra/datasources/i_product_datasource.dart';

class ProductFirebaseDatasourceImpl implements IProductDatasource {
  final firebase = FirebaseHelperImpl();

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final result = await firebase
        .getProductCollection()
        .add(product.toMap())
        .catchError(
            (e) => throw FirebaseException(plugin: 'CREATE PRODUCT ERROR'));

    product.id = result.id;

    await updateProduct(product);
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await firebase.getProductCollection().doc(product.id).update(product.toMap());
    await _updateStock(product);
    await _updateOrder(product);

    return product;
  }

  _updateStock(ProductModel product) async {
    final stockSnap = await firebase
        .getStockCollection()
        .where('product.id', isEqualTo: product.id)
        .get();

    for (var s in stockSnap.docs) {
      firebase
          .getStockCollection()
          .doc(s.id)
          .update({'product': product.toMap()});
    }
  }

  _updateOrder(ProductModel product) async {
    final productOnOrderDoc =
        await firebase.getProductOnOrderCollection().doc(product.id).get();

    if (productOnOrderDoc.exists) {
      List orderList = productOnOrderDoc.get('orderList');

      for (var o in orderList) {
        final orderSnap = await firebase.getOrderCollection().doc(o).get();

        var order = OrderModel.fromMap(
            map: orderSnap.data() as Map<String, dynamic>,
            orderItemList:
                _getOrderItemList(orderSnap.data() as Map<String, dynamic>));

        var orderItemFromProduct = order.orderItemList
            .singleWhere((element) => element.product.id == product.id);

        orderItemFromProduct.product = product;

        GetIt.I.get<IOrderDatasource>().updateOrder(order);
      }
    }
  }

  _getOrderItemList(Map<String, dynamic> map) {
    List<OrderItemModel> itemList = [];

    for (var e in map['orderItemList']) {
      itemList.add(OrderItemModel.fromMap(map: e));
    }

    return itemList;
  }

  @override
  Future<List<ProductModel>> getEnabledProductListByProvider(
      String providerId) async {
    List<ProductModel> productList = [];

    final snap = await firebase
        .getProductCollection()
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

    final snap = await firebase
        .getProductCollection()
        .orderBy('name', descending: false)
        .get();

    for (var p in snap.docs) {
      productList.add(ProductModel.fromMap(map: p.data()));
    }

    return productList;
  }

  @override
  Future<List<ProductModel>> getProductListByEnabled() async {
    List<ProductModel> productList = [];

    final snap = await firebase
        .getProductCollection()
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

    final snapshot = await firebase
        .getProductCollection()
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
      firebase
          .getProductCollection()
          .doc(p.id)
          .set(ProductModel.fromMap(map: p.data()).toMap());
    }
  }
}
