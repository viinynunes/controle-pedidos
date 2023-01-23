import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';

import '../decrease_stock_total_ordered_usecase.dart';

class DecreaseStockTotalOrderedUsecaseImpl
    implements DecreaseStockTotalOrderedUsecase {
  final INewStockRepository _repository;

  DecreaseStockTotalOrderedUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> call(
      {required String stockID, required int decreaseQuantity}) async {
    if (stockID.isEmpty) {
      return Left(StockError('Stock ID cannot be empty'));
    }

    if (decreaseQuantity <= 0) {
      return Left(
          StockError('increase quantity cannot be a non positive number'));
    }

    return _repository.decreaseTotalOrderedFromStock(
        stockID: stockID, decreaseQuantity: decreaseQuantity);
  }
}
