import 'package:dartz/dartz.dart';

import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class ChangeStockProviderUsecase {
  Future<Either<StockError, Stock>> moveStockWithProperties(
      {required String stockID, required Provider newProvider});

  Future<Either<StockError, Stock>> duplicateStockWithoutProperties(
      {required String stockID, required Provider newProvider});
}
