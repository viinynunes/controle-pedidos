import 'package:controle_pedidos/src/domain/entities/product.dart';

class StockMock {
  static String getStockCodeFromProduct(
      {required Product product, required DateTime date}) {
    return product.id +
        product.provider.id +
        DateTime(date.year, date.month, date.day).toString();
  }
}
