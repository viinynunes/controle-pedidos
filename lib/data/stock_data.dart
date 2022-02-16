import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/product_data.dart';

class StockData {

  StockData(this.total, this.left, this.creationDate, this.product);

  StockData.fromMap(this.id, Map<String, dynamic> map) {
    total = map['total'];
    left = map['left'];
    Timestamp timeStamp = map['creationDate'];
    creationDate = DateTime.parse(timeStamp.toDate().toString());
    product = ProductData.fromMap(map['product']);
  }

  String? id;
  late int total;
  late int left;
  late DateTime creationDate;

  late ProductData product;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'left': left,
      'creationDate': creationDate,
      'product': product.toMap(),
    };
  }


}
