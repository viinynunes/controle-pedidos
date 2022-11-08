import 'package:controle_pedidos/src/domain/entities/product.dart';

class Stock {
  String id;
  int total;
  int totalOrdered;
  DateTime registrationDate;

  Product product;

  Stock(
      {required this.id,
      required this.total,
      required this.totalOrdered,
      required this.registrationDate,
      required this.product});
}
