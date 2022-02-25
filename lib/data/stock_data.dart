import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/product_data.dart';

class StockData {

  StockData(this.total, this.totalOrdered, this.creationDate, this.product);

  StockData.fromMap(this.id, Map<String, dynamic> map) {
    total = map['total'];
    totalOrdered = map['totalOrdered'];
    Timestamp timeStamp = map['creationDate'];
    creationDate = DateTime.parse(timeStamp.toDate().toString());
    product = ProductData.fromMap(map['product']);
  }

  String? id;
  late int total;
  late int totalOrdered;
  late DateTime creationDate;

  late ProductData product;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'totalOrdered': totalOrdered,
      'creationDate': creationDate,
      'product': product.toMap(),
    };
  }

  @override
  bool operator ==(Object other) {
    if(other is! StockData){
      return false;
    }
    return id == (other).id || product.id == (other).product.id;
  }

  @override
  int get hashCode => id.hashCode;



}
