import 'package:dartz/dartz.dart';

import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class GetStockListsUsecase {
  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate});

  Future<Either<StockError, List<Stock>>> getStockListByProviderBetweenDates(
      {required Provider provider,
      required DateTime iniDate,
      required DateTime endDate});

  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate});
}
