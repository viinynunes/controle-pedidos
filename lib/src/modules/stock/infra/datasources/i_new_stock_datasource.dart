import '../../../../domain/models/product_model.dart';
import '../../../../domain/models/provider_model.dart';
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

  Future<StockModel> increaseTotalOrderedFromStock(
      {required String stockID, required int increaseQuantity});

  Future<StockModel> decreaseTotalOrderedFromStock(
      {required String stockID, required int decreaseQuantity});

  Future<StockModel> deleteStock(StockModel stock);

  Future<StockModel> changeStockDate(
      {required String stockId, required DateTime newDate});

  Future<Set<ProviderModel>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate});

  Future<List<StockModel>> getStockListByProviderBetweenDates(
      {required ProviderModel provider,
      required DateTime iniDate,
      required DateTime endDate});

  Future<List<StockModel>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate});
}
