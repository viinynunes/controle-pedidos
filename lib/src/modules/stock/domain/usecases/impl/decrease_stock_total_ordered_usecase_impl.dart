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
      return Left(StockError('O ID do estoque não pode estar vazio'));
    }

    if (decreaseQuantity <= 0) {
      return Left(
          StockError('A quantidade não pode ser menor que 1'));
    }

    return _repository.decreaseTotalOrderedFromStock(
        stockID: stockID, decreaseQuantity: decreaseQuantity);
  }
}
