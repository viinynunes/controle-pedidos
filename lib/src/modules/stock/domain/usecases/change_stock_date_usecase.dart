import 'package:dartz/dartz.dart';

import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class ChangeStockDateUsecase {
  Future<Either<StockError, Stock>> call(
      {required String stockId, required DateTime newDate});
}