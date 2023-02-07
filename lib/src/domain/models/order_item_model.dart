import 'package:controle_pedidos/src/domain/entities/order_item.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel(
      {required super.listIndex,
      required super.quantity,
      required super.product,
      required super.note});

  OrderItemModel.fromOrderItem({required OrderItem item})
      : super(
            listIndex: item.listIndex,
            quantity: item.quantity,
            product: item.product,
            note: item.note);

  OrderItemModel.fromMap({required Map<String, dynamic> map})
      : super(
            listIndex: map['listIndex'],
            quantity: map['quantity'],
            product: ProductModel.fromMap(map: map['product']),
            note: map['note']);

  Map<String, dynamic> toMap() {
    return {
      'listIndex': listIndex,
      'quantity': quantity,
      'product': ProductModel.fromProduct(product: product).toMap(),
      'note': note
    };
  }

  @override
  String toString() {
    return '$quantity ${product.category} ${product.name}';
  }
}
