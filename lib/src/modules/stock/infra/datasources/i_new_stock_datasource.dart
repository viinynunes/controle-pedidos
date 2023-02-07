import '../../../../domain/models/provider_model.dart';
import '../../../../domain/models/stock_model.dart';

abstract class INewStockDatasource {
  Future<StockModel> createStock({required StockModel stock, String stockID = ''});

  Future<StockModel> updateStock({required StockModel stock});

  Future<StockModel> deleteStock({required StockModel stock});

  Future<StockModel?> getStockByCode({required String code});

  Future<StockModel> getStockById({required String id});

  Future<Set<ProviderModel>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate});

  Future<List<StockModel>> getStockListByProviderBetweenDates(
      {required ProviderModel provider,
      required DateTime iniDate,
      required DateTime endDate});

  Future<List<StockModel>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate});
}
