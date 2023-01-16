import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';

import 'product_mock.dart';

class StockMock {
  static String getStockCodeFromProduct(
      {required Product product, required DateTime date}) {
    return product.id +
        product.provider.id +
        DateTime(date.year, date.month, date.day).toString();
  }

  static StockModel getOneStock(
      {String id = 'stockID-001',
      String? code,
      int total = 2,
      int totalOrdered = 3,
      DateTime? registrationDate,
      ProductModel? product}) {
    return StockModel(
        id: id,
        code: code ??
            getStockCodeFromProduct(
                product: product ?? ProductMock.getOneProduct(),
                date: registrationDate ?? DateTime.now()),
        total: total,
        totalOrdered: totalOrdered,
        registrationDate: registrationDate ?? DateTime.now(),
        product: product ?? ProductMock.getOneProduct());
  }
}
