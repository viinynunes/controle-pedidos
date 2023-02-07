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

    if (stock.product.provider.id.isEmpty) {
      return Left(StockError('Product provider cannot be empty'));
    }

    if (stock.total.isNegative) {
      return Left(StockError('Stock total cannot be negative'));
    }

    return _repository.createStock(stock);
  }

  @override
  Future<Either<StockError, Stock>> updateStock(Stock stock) async {
    if (stock.id.isEmpty) {
      return Left(StockError('Id cannot be empty'));
    }

    if (stock.product.id.isEmpty) {
      return Left(StockError('Product id cannot be empty'));
    }

    if (stock.product.provider.id.isEmpty) {
      return Left(StockError('Product provider cannot be empty'));
    }

    if (stock.total.isNegative) {
      return Left(StockError('Stock total cannot be negative'));
    }

    return _repository.updateStock(stock);
  }

  @override
  Future<Either<StockError, Stock>> updateStockDate(
      Stock toDeleteStock, Stock updatedStock) async {
    if (toDeleteStock.id.isEmpty) {
      return Left(StockError('to delete stock id cannot be empty'));
    }

    if (updatedStock.id.isEmpty) {
      return Left(StockError('updated stock id cannot be empty'));
    }

    if (updatedStock.product.id.isEmpty) {
      return Left(StockError('Product id cannot be empty'));
    }

    if (updatedStock.product.provider.id.isEmpty) {
      return Left(StockError('Product provider cannot be empty'));
    }

    if (updatedStock.total.isNegative) {
      return Left(StockError('Stock total cannot be negative'));
    }

    return _repository.updateStockDate(toDeleteStock, updatedStock);
  }

  @override
  Future<Either<StockError, Stock>> updateStockByEndDate(
      Stock stock, DateTime endDate, bool increase) async {
    if (stock.id.isEmpty) {
      return Left(StockError('to delete stock id cannot be empty'));
    }

    if (stock.id.isEmpty) {
      return Left(StockError('updated stock id cannot be empty'));
    }

    if (stock.product.id.isEmpty) {
      return Left(StockError('Product id cannot be empty'));
    }

    if (stock.product.provider.id.isEmpty) {
      return Left(StockError('Product provider cannot be empty'));
    }

    if (stock.total.isNegative) {
      return Left(StockError('Stock total cannot be negative'));
    }

    return _repository.updateStockByEndDate(stock, endDate, increase);
  }

  @override
  Future<Either<StockError, Stock>> createDuplicatedStock(Stock stock) {
    // TODO: implement createDuplicatedStock
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
  Future<Either<StockError, bool>> deleteStock(Stock stock) async {
    if (stock.id.isEmpty) {
      return Left(StockError('Id cannot be empty'));
    }

    return _repository.deleteStock(stock);
  }

  @override
  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      DateTime iniDate, DateTime endDate) {
    return _repository.getProviderListByStockBetweenDates(iniDate, endDate);
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) {
    return _repository.getStockListBetweenDates(
        iniDate: iniDate, endDate: endDate);
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
