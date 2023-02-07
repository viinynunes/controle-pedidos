import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/entities/product.dart';
import '../../errors/stock_error.dart';

abstract class DecreaseStockTotalUsecase {
  Future<Either<StockError, Stock>> call(
      {required Product product,
      required DateTime date,
      required int decreaseQuantity});
}
