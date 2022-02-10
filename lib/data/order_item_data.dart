import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/product_data.dart';

class OrderItemData {

  OrderItemData({required this.quantity, required this.product, this.note});

  OrderItemData.fromDocSnapshot(DocumentSnapshot snapshot){
    id = snapshot.id;
    note = snapshot.get('note');
    quantity = snapshot.get('quantity');
    product = ProductData.fromMap(snapshot.get('product'));
  }

  OrderItemData.fromMap(Map<String, dynamic> map){
    id = map['id'];
    note = map['note'];
    quantity = map['quantity'];
    product = ProductData.fromMap(map['product']);
    //order = OrderData.fromMap(map['order']);
  }

  String? id;
  String? note;
  late int quantity;
  late ProductData product;
  OrderData? order;

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'note': note,
      'quantity': quantity,
      'product': product.toMap(),
      //'order': order.toMap()
    };
  }

  @override
  String toString() {
    return super.toString();
  }
}