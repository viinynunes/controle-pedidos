import 'package:controle_pedidos/src/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel(
      {required super.id,
      required super.productId,
      required super.productName,
      required super.quantity,
      super.note});

  OrderItemModel.fromOrderItem({required OrderItem item})
      : super(
            id: item.id,
            productId: item.productId,
            productName: item.productName,
            quantity: item.quantity,
            note: item.note);

  OrderItemModel.fromMap({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            productId: map['productId'],
            productName: map['productName'],
            quantity: map['quantity'],
            note: map['note']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'note': note
    };
  }
}
