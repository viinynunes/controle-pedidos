import 'package:dartz/dartz.dart';

import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class DecreaseStockTotalOrderedUsecase {
  Future<Either<StockError, Stock>> call(
      {required String stockID, required int decreaseQuantity});
}
