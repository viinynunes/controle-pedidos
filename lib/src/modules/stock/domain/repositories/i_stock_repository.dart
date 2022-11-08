import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class IStockRepository {
  Future<Either<StockError, Stock>> createStock();

  Future<Either<StockError, Stock>> createDuplicatedStock();

  Future<Either<StockError, Stock>> updateStock();

  Future<Either<StockError, Stock>> increaseStock(Stock stock);

  Future<Either<StockError, Stock>> decreaseStock(Stock stock);

  Future<Either<StockError, bool>> deleteStock();

  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      DateTime iniDate, DateTime endDate);

  Future<Either<StockError, List<Stock>>> getStockListByProviderBetweenDates(
      {required Provider provider,
      required DateTime iniDate,
      required DateTime endDate});

  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate});
}
