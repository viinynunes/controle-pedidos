import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/models/stock_model.dart';
import '../../domain/repositories/i_stock_repository.dart';
import '../datasources/i_stock_datasource.dart';

class StockRepositoryImpl implements IStockRepository {
  final IStockDatasource _datasource;

  StockRepositoryImpl(this._datasource);

  @override
  Future<Either<StockError, Stock>> createStock(Stock stock) async {
    try {
      final result = await _datasource.createStock(StockModel.fromStock(stock));

      return Right(result);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Stock>> createDuplicatedStock(Stock stock) {
    // TODO: implement createDuplicatedStock
    throw UnimplementedError();
  }

  @override
  Future<Either<StockError, Stock>> updateStock(Stock stock) {
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
      DateTime iniDate, DateTime endDate) async {
    try {
      final result = await _datasource.getProviderListByStockBetweenDates(
          iniDate, endDate);

      return Right(result);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
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
