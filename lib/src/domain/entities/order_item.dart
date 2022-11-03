class OrderItem {
  String id;
  String productId;
  String productName;
  int quantity;
  String? note;

  OrderItem(
      {required this.id,
        required this.productId,
        required this.productName,
        required this.quantity,
        this.note});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OrderItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
