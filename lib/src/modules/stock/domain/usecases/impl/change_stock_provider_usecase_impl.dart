import 'package:controle_pedidos/src/domain/entities/provider.dart';

import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';

import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';

import 'package:dartz/dartz.dart';

import '../change_stock_provider_usecase.dart';

class ChangeStockProviderUsecaseImpl implements ChangeStockProviderUsecase {
  final INewStockRepository _repository;

  ChangeStockProviderUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Stock>> duplicateStockWithoutProperties(
      {required String stockID, required Provider newProvider}) async {
    if (stockID.isEmpty) {
      return Left(StockError('O ID do estoque não pode estar vazio'));
    }

    if (newProvider.id.isEmpty) {
      return Left(StockError('O ID do fornecedor não pode estar vazio'));
    }

    return _repository.duplicateStockWithoutProperties(
        stockID: stockID, newProvider: newProvider);
  }

  @override
  Future<Either<StockError, Stock>> moveStockWithProperties(
      {required String stockID, required Provider newProvider}) async {
    if (stockID.isEmpty) {
      return Left(StockError('O ID do estoque não pode estar vazio'));
    }

    if (newProvider.id.isEmpty) {
      return Left(StockError('O ID do novo fornecedor não pode estar vazio'));
    }

    return _repository.moveStockWithProperties(
        stockID: stockID, newProvider: newProvider);
  }
}
