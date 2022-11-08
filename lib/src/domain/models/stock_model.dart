import 'package:controle_pedidos/src/modules/core/helpers.dart';

import '../entities/stock.dart';
import 'product_model.dart';

class StockModel extends Stock {
  StockModel(
      {required super.id,
      required super.total,
      required super.totalOrdered,
      required super.registrationDate,
      required super.product});

  StockModel.fromStock(Stock stock)
      : super(
          id: stock.id,
          total: stock.total,
          totalOrdered: stock.totalOrdered,
          registrationDate: stock.registrationDate,
          product: stock.product,
        );

  StockModel.fromMap(Map<String, dynamic> map)
      : super(
          id: map['id'],
          total: map['total'],
          totalOrdered: map['totalOrdered'],
          registrationDate:
              Helpers.convertTimestampToDateTime(map['registrationDate']),
          product: ProductModel.fromMap(map: map['product']),
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'totalOrdered': totalOrdered,
      'registrationDate': registrationDate,
      'product': ProductModel.fromProduct(product: product).toMap(),
    };
  }
}
