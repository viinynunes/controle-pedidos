import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';

import '../infra/datasources/i_stock_datasource.dart';

class StockFirebaseDatasourceImpl implements IStockDatasource {
  @override
  Future<StockModel> createStock() {
    // TODO: implement createStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> createDuplicatedStock() {
    // TODO: implement createDuplicatedStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> increaseStock(StockModel stock) {
    // TODO: implement increaseStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> decreaseStock(StockModel stock) {
    // TODO: implement decreaseStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> updateStock() {
    // TODO: implement updateStock
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteStock() {
    // TODO: implement deleteStock
    throw UnimplementedError();
  }

  @override
  Future<Set<ProviderModel>> getProviderListByStockBetweenDates(
      DateTime iniDate, DateTime endDate) {
    // TODO: implement getProviderListByStockBetweenDates
    throw UnimplementedError();
  }

  @override
  Future<List<StockModel>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) {
    // TODO: implement getStockListBetweenDates
    throw UnimplementedError();
  }

  @override
  Future<List<StockModel>> getStockListByProviderBetweenDates(
      {required ProviderModel provider,
      required DateTime iniDate,
      required DateTime endDate}) {
    // TODO: implement getStockListByProviderBetweenDates
    throw UnimplementedError();
  }
}
