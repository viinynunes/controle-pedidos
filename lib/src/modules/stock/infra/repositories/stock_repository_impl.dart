import 'package:controle_pedidos/src/domain/entities/provider.dart';

import 'package:controle_pedidos/src/domain/entities/stock.dart';

import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/i_stock_repository.dart';

class StockRepositoryImpl implements IStockRepository {
  @override
  Future<Either<StockError, Stock>> createStock() {
    // TODO: implement createStock
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, Stock>> createDuplicatedStock() {
    // TODO: implement createDuplicatedStock
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, Stock>> updateStock() {
    // TODO: implement updateStock
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, Stock>> increaseStock(Stock stock) {
    // TODO: implement increaseStock
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, Stock>> decreaseStock(Stock stock) {
    // TODO: implement decreaseStock
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, bool>> deleteStock() {
    // TODO: implement deleteStock
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      DateTime iniDate, DateTime endDate) {
    // TODO: implement getProviderListByStockBetweenDates
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) {
    // TODO: implement getStockListBetweenDates
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListByProviderBetweenDates(
      {required Provider provider,
        required DateTime iniDate,
        required DateTime endDate}) {
    // TODO: implement getStockListByProviderBetweenDates
    throw UnimplementedError();
  }

}