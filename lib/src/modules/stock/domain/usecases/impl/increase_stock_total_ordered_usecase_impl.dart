import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';

import '../increase_stock_total_ordered_usecase.dart';

class IncreaseStockTotalOrderedUsecaseImpl
    implements IncreaseStockTotalOrderedUsecase {
  final INewStockRepository _repository;

  IncreaseStockTotalOrderedUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> call(
      {required String stockID, required int increaseQuantity}) async {
    if (stockID.isEmpty) {
      return Left(StockError('Stock ID cannot be empty'));
    }

    if (increaseQuantity <= 0) {
      return Left(
          StockError('increase quantity cannot be a non positive number'));
    }

    return _repository.increaseTotalOrderedFromStock(
        stockID: stockID, increaseQuantity: increaseQuantity);
  }
}
