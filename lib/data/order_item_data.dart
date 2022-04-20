import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/product_data.dart';

class OrderItemData {
  OrderItemData(
      {required this.id,
      required this.quantity,
      required this.product,
      this.note,
      required this.productID});

  OrderItemData.fromDocSnapshot(DocumentSnapshot snapshot, this.product) {
    id = snapshot.id;
    note = snapshot.get('note');
    quantity = snapshot.get('quantity');
    productID = snapshot.get('productID');
  }

  OrderItemData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    note = map['note'];
    quantity = map['quantity'];
    productID = map['productID'];
    product = ProductData.fromMap(map['product']);
  }

  String? id;
  String? note;
  late int quantity;
  late String productID;
  late ProductData product;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'quantity': quantity,
      'productID': productID,
      'product': product.name,
    };
  }

  Map<String, dynamic> toCompleteMap() {
    return {
      'id': id,
      'note': note,
      'quantity': quantity,
      'productID': productID,
      'product': product.toMap(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is! OrderItemData) {
      return false;
    }

    return product.id == (other).product.id;
  }

  @override
  int get hashCode => id.hashCode;
}
