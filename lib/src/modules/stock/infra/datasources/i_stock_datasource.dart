import '../../../../domain/models/provider_model.dart';
import '../../../../domain/models/stock_model.dart';

abstract class IStockDatasource {
  Future<StockModel> createStock();

  Future<StockModel> createDuplicatedStock();

  Future<StockModel> updateStock();

  Future<StockModel> increaseStock(StockModel stock);

  Future<StockModel> decreaseStock(StockModel stock);

  Future<bool> deleteStock();

  Future<Set<ProviderModel>> getProviderListByStockBetweenDates(
      DateTime iniDate, DateTime endDate);

  Future<List<StockModel>> getStockListByProviderBetweenDates(
      {required ProviderModel provider,
      required DateTime iniDate,
      required DateTime endDate});

  Future<List<StockModel>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate});
}
