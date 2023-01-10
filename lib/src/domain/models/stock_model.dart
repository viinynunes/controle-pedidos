

import '../../core/helpers.dart';
import '../entities/stock.dart';
import 'product_model.dart';

class StockModel extends Stock {
  StockModel(
      {required super.id,
        required super.code,
      required super.total,
      required super.totalOrdered,
      required super.registrationDate,
      required super.product});

  StockModel.fromStock(Stock stock)
      : super(
          id: stock.id,
          code: stock.code,
          total: stock.total,
          totalOrdered: stock.totalOrdered,
          registrationDate: stock.registrationDate,
          product: stock.product,
        );

  StockModel.fromMap(Map<String, dynamic> map)
      : super(
          id: map['id'],
          code: map['code'],
          total: map['total'],
          totalOrdered: map['totalOrdered'],
          registrationDate:
              Helpers.convertTimestampToDateTime(map['registrationDate']),
          product: ProductModel.fromMap(map: map['product']),
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'total': total,
      'totalOrdered': totalOrdered,
      'registrationDate': registrationDate,
      'product': ProductModel.fromProduct(product: product).toMap(),
    };
  }
}
