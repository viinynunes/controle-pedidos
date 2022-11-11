import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';

import '../../repositories/i_stock_repository.dart';
import '../i_stock_usecase.dart';

class StockUsecaseImpl implements IStockUsecase {
  final IStockRepository _repository;

  StockUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> createStock(Stock stock) async {
    if (stock.product.id.isEmpty) {
      return Left(StockError('Product id cannot be empty'));
    }

    if (stock.product.providerId.isEmpty) {
      return Left(StockError('Product provider cannot be empty'));
    }

    if (stock.total.isNegative) {
      return Left(StockError('Stock total cannot be negative'));
    }

    return _repository.createStock(stock);
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
      DateTime iniDate, DateTime endDate) {
    return _repository.getProviderListByStockBetweenDates(iniDate, endDate);
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
    return _repository.getStockListByProviderBetweenDates(
        provider: provider, iniDate: iniDate, endDate: endDate);
  }
}
