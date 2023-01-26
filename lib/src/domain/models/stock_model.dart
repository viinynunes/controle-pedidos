import 'package:cloud_firestore/cloud_firestore.dart';

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

  StockModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : super(
            id: doc.id,
            code: doc.get('code'),
            total: doc.get('total'),
            totalOrdered: doc.get('totalOrdered'),
            registrationDate:
                DateTimeHelper.convertTimestampToDateTime(doc.get('registrationDate')),
            product: ProductModel.fromMap(map: doc.get('product')));

  StockModel.fromMap(Map<String, dynamic> map)
      : super(
          id: map['id'],
          code: map['code'],
          total: map['total'],
          totalOrdered: map['totalOrdered'],
          registrationDate:
              DateTimeHelper.convertTimestampToDateTime(map['registrationDate']),
          product: ProductModel.fromMap(map: map['product']),
        );

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'total': total,
      'totalOrdered': totalOrdered,
      'registrationDate': registrationDate,
      'product': ProductModel.fromProduct(product: product).toMap(),
    };
  }

  @override
  String toString() {
    return 'total: $total / totalOrdered: $totalOrdered / product: ${product.name}';
  }
}
