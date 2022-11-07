import 'product.dart';

class OrderItem {
  String productId;
  int quantity;
  String note;

  Product product;

  OrderItem(
      {required this.productId,
      required this.quantity,
      required this.product,
      required this.note});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}
