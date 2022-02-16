import 'package:controle_pedidos/data/product_data.dart';

class StockData {

  StockData(this.id, this.total, this.left, this.creationDate, this.product);

  StockData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    total = map['total'];
    left = map['left'];
    creationDate = map['creationDate'];
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
