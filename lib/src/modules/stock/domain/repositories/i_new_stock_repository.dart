import 'package:dartz/dartz.dart';

import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class INewStockRepository {
  Future<Either<StockError, Stock>> increaseTotalFromStock(
      {required Product product,
      required DateTime date,
      required int increaseQuantity});

  Future<Either<StockError, Stock>> decreaseTotalFromStock(
      {required Product product,
      required DateTime date,
      required int decreaseQuantity});

  Future<Either<StockError, Stock>> changeStockDate(
      {required String stockId, required DateTime newDate});

  Future<Either<StockError, Stock>> increaseTotalOrderedFromStock(
      {required String stockID, required int increaseQuantity});

  Future<Either<StockError, Stock>> decreaseTotalOrderedFromStock(
      {required String stockID, required int decreaseQuantity});

  Future<Either<StockError, Stock>> updateStock(Stock stock);

  Future<Either<StockError, Stock>> deleteStock(Stock stock);

  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate});

  Future<Either<StockError, List<Stock>>> getStockListByProviderBetweenDates(
      {required Provider provider,
      required DateTime iniDate,
      required DateTime endDate});

  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate});
}
