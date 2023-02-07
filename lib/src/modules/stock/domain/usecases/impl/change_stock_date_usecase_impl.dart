import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';

import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';

import 'package:dartz/dartz.dart';

import '../change_stock_date_usecase.dart';

class ChangeStockDateUsecaseImpl implements ChangeStockDateUsecase {
  final INewStockRepository _repository;

  ChangeStockDateUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> call(
      {required String stockId, required DateTime newDate}) async {
    if (stockId.isEmpty) {
      return Left(StockError('Stock ID cannot be empty'));
    }

    return _repository.changeStockDate(stockId: stockId, newDate: newDate);
  }
}
