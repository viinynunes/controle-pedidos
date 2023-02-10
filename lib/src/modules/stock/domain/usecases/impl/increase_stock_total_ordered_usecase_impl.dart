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
      return Left(StockError('O ID do estoque não pode estar vazio'));
    }

    if (increaseQuantity <= 0) {
      return Left(
          StockError('A quantidade não pode ser menor que 1'));
    }

    return _repository.increaseTotalOrderedFromStock(
        stockID: stockID, increaseQuantity: increaseQuantity);
  }
}
