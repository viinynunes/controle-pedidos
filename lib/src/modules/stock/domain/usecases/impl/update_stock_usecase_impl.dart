import 'package:controle_pedidos/src/domain/entities/stock.dart';

import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';

import 'package:dartz/dartz.dart';

import '../../repositories/i_new_stock_repository.dart';
import '../update_stock_usecase.dart';

class UpdateStockUsecaseImpl implements UpdateStockUsecase {
  final INewStockRepository _repository;

  UpdateStockUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> call(Stock stock) async {
    if (stock.id.isEmpty) {
      return Left(StockError('O ID do estoque não pode estar vazio'));
    }

    return await _repository.updateStock(stock);
  }
}
