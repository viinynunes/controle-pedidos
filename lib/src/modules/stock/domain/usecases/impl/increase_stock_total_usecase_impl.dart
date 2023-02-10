import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';

import '../increase_stock_total_usecase.dart';

class IncreaseStockTotalUsecaseImpl implements IncreaseStockTotalUsecase {
  final INewStockRepository _repository;

  IncreaseStockTotalUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> call(
      {required Product product,
      required DateTime date,
      required int increaseQuantity}) async {
    if (product.id.isEmpty) {
      return Left(StockError('O ID do produto não pode estar vazio'));
    }

    if (increaseQuantity < 0) {
      return Left(
          StockError('A quantidade não pode ser menor que 1'));
    }

    return await _repository.increaseTotalFromStock(
        product: product, date: date, increaseQuantity: increaseQuantity);
  }
}
