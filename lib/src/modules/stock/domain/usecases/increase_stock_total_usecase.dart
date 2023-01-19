import 'package:dartz/dartz.dart';

import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class IncreaseStockTotalUsecase {
  Future<Either<StockError, Stock>> call(
      {required Product product,
      required DateTime date,
      required int increaseQuantity});
}
