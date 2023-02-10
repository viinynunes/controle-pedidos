import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';

import '../../repositories/i_new_stock_repository.dart';
import '../decrease_stock_total_usecase.dart';

class DecreaseStockTotalUsecaseImpl implements DecreaseStockTotalUsecase {
  final INewStockRepository _repository;

  DecreaseStockTotalUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> call(
      {required Product product,
      required DateTime date,
      required int decreaseQuantity}) async {
    if (product.id.isEmpty) {
      return Left(StockError('O ID do produto não pode estar vazio'));
    }

    if (decreaseQuantity <= 0) {
      return Left(
          StockError('A quantidade não pode ser menor que 1'));
    }

    return _repository.decreaseTotalFromStock(
        product: product, date: date, decreaseQuantity: decreaseQuantity);
  }
}
