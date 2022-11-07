import 'package:controle_pedidos/src/domain/entities/order_item.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel(
      {required super.productId,
      required super.quantity,
      required super.product,
      super.note});

  OrderItemModel.fromOrderItem({required OrderItem item})
      : super(
            productId: item.productId,
            quantity: item.quantity,
            product: item.product,
            note: item.note);

  OrderItemModel.fromMap({required Map<String, dynamic> map})
      : super(
            productId: map['productId'],
            quantity: map['quantity'],
            product: map['product'],
            note: map['note']);

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'product': ProductModel.fromProduct(product: product),
      'note': note
    };
  }
}
