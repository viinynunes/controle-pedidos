import '../../../../domain/models/product_model.dart';
import '../../../../domain/models/stock_model.dart';

abstract class INewStockDatasource {
  Future<StockModel> increaseTotalFromStock(
      {required ProductModel product,
      required DateTime date,
      required int increaseQuantity});

  Future<StockModel> decreaseTotalFromStock(
      {required ProductModel product,
      required DateTime date,
      required int decreaseQuantity,
      bool deleteIfEmpty = false});
}
