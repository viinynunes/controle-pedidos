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
  Future<Either<StockError, Stock>> call({required String stockID, required Provider newProvider}) async {
    if(stockID.isEmpty){
      return Left(StockError('Stock ID cannot be empty'));
    }

    if (newProvider.id.isEmpty){
      return Left(StockError('Provider ID cannot be empty'));
    }

    return _repository.changeStockProvider(stockID: stockID, newProvider: newProvider);
  }

}