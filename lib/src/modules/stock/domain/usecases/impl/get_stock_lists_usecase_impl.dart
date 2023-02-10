import 'package:controle_pedidos/src/domain/entities/provider.dart';

import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';

import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';

import 'package:dartz/dartz.dart';

import '../get_stock_lists_usecase.dart';

class GetStockListsUsecaseImpl implements GetStockListsUsecase {
  final INewStockRepository _repository;

  GetStockListsUsecaseImpl(this._repository);

  @override
  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) {
    return _repository.getProviderListByStockBetweenDates(
        iniDate: iniDate, endDate: endDate);
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) {
    return _repository.getStockListBetweenDates(
        iniDate: iniDate, endDate: endDate);
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListByProviderBetweenDates(
      {required Provider provider,
      required DateTime iniDate,
      required DateTime endDate}) async {
    if (provider.id.isEmpty) {
      return Left(StockError('O ID do fornecedor não pode estar vazio'));
    }

    return _repository.getStockListByProviderBetweenDates(
        provider: provider, iniDate: iniDate, endDate: endDate);
  }
}
