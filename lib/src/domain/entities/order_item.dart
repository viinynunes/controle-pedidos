import 'product.dart';

class OrderItem {
  int listIndex;
  String productId;
  int quantity;
  String note;

  Product product;

  OrderItem(
      {required this.listIndex,
      required this.productId,
      required this.quantity,
      required this.product,
      required this.note});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          product == other.product;

  @override
  int get hashCode => product.hashCode;
}
