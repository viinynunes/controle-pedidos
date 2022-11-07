import 'package:controle_pedidos/src/domain/entities/order_item.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel(
      {required super.listIndex,
      required super.productId,
      required super.quantity,
      required super.product,
      required super.note});

  OrderItemModel.fromOrderItem({required OrderItem item})
      : super(
            listIndex: item.listIndex,
            productId: item.productId,
            quantity: item.quantity,
            product: item.product,
            note: item.note);

  OrderItemModel.fromMap({required Map<String, dynamic> map})
      : super(
            listIndex: map['listIndex'],
            productId: map['productId'],
            quantity: map['quantity'],
            product: map['product'],
            note: map['note']);

  Map<String, dynamic> toMap() {
    return {
      'listIndex': listIndex,
      'productId': productId,
      'quantity': quantity,
      'product': ProductModel.fromProduct(product: product),
      'note': note
    };
  }
}
