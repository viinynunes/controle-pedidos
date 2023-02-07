import 'package:dartz/dartz.dart';

import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class DeleteStockUsecase {
  Future<Either<StockError, Stock>> call(Stock stock);
}
