import 'dart:developer';

import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:controle_pedidos/src/modules/stock/infra/datasources/i_new_stock_datasource.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/stock/stock_helper.dart';
import '../../../../core/date_time_helper.dart';
import '../../../../core/exceptions/external_exception.dart';
import '../../../../domain/models/product_model.dart';
import '../../../../domain/models/provider_model.dart';
import '../../../../domain/models/stock_model.dart';

class NewStockRepositoryImpl implements INewStockRepository {
  final INewStockDatasource _datasource;

  NewStockRepositoryImpl(this._datasource);

  @override
  Future<Either<StockError, Stock>> changeStockDate(
      {required String stockId, required DateTime newDate}) async {
    try {
      var stock = await _datasource.getStockById(id: stockId);
      stock.registrationDate = newDate;
      stock.code = StockHelper.getStockCode(
          product: stock.product, date: stock.registrationDate);

      var stockWithNewDateInDB =
          await _datasource.getStockByCode(code: stock.code);

      await _datasource.deleteStock(stock: stock);
      if (stockWithNewDateInDB == null) {
        return Right(
            await _datasource.createStock(stock: stock, stockID: stockId));
      } else {
        stockWithNewDateInDB.total += stock.total;
        stockWithNewDateInDB.totalOrdered += stock.totalOrdered;

        return Right(
            await _datasource.updateStock(stock: stockWithNewDateInDB));
      }
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> decreaseTotalFromStock(
      {required Product product,
      required DateTime date,
      required int decreaseQuantity}) async {
    try {
      var stock = StockHelper.getNewStock(product: product, date: date);

      final stockFromDB = await _datasource.getStockByCode(code: stock.code);

      if (stockFromDB == null) {
        throw StockError('Stock não encontrado - CODE ${stock.code}');
      }

      stockFromDB.total -= decreaseQuantity;

      return stockFromDB.total == 0 && stockFromDB.totalOrdered == 0
          ? Right(await _datasource.deleteStock(stock: stockFromDB))
          : Right(await _datasource.updateStock(stock: stockFromDB));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> decreaseTotalOrderedFromStock(
      {required String stockID, required int decreaseQuantity}) async {
    try {
      var stock = await _datasource.getStockById(id: stockID);

      stock.totalOrdered -= decreaseQuantity;

      return Right(await _datasource.updateStock(stock: stock));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> deleteStock(Stock stock) async {
    try {
      return Right(
          await _datasource.deleteStock(stock: StockModel.fromStock(stock)));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) async {
    try {
      iniDate = DateTimeHelper.removeHourFromDateTime(date: iniDate);
      endDate = DateTimeHelper.removeHourFromDateTime(date: endDate);

      return Right(await _datasource.getProviderListByStockBetweenDates(
          iniDate: iniDate, endDate: endDate));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) async {
    try {
      iniDate = DateTimeHelper.removeHourFromDateTime(date: iniDate);
      endDate = DateTimeHelper.removeHourFromDateTime(date: endDate);

      var list = await _datasource.getStockListBetweenDates(
          iniDate: iniDate, endDate: endDate);

      return Right(StockHelper.mergeStockList(stockListFromDB: list));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListByProviderBetweenDates(
      {required Provider provider,
      required DateTime iniDate,
      required DateTime endDate}) async {
    try {
      iniDate = DateTimeHelper.removeHourFromDateTime(date: iniDate);
      endDate = DateTimeHelper.removeHourFromDateTime(date: endDate);

      var list = await _datasource.getStockListByProviderBetweenDates(
          provider: ProviderModel.fromProvider(provider),
          iniDate: iniDate,
          endDate: endDate);

      return Right(StockHelper.mergeStockList(stockListFromDB: list));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> increaseTotalFromStock(
      {required Product product,
      required DateTime date,
      required int increaseQuantity}) async {
    try {
      final stock = StockHelper.getNewStock(
          product: ProductModel.fromProduct(product: product),
          date: date,
          total: increaseQuantity);

      final stockFromDB = await _datasource.getStockByCode(code: stock.code);

      if (stockFromDB != null) {
        stockFromDB.total += increaseQuantity;
        return Right(await _datasource.updateStock(
            stock: StockModel.fromStock(stockFromDB)));
      } else {
        return Right(
            await _datasource.createStock(stock: StockModel.fromStock(stock)));
      }
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> increaseTotalOrderedFromStock(
      {required String stockID, required int increaseQuantity}) async {
    try {
      var stock = await _datasource.getStockById(id: stockID);

      stock.totalOrdered += increaseQuantity;

      return Right(await _datasource.updateStock(stock: stock));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> updateStock(Stock stock) async {
    try {
      return Right(
          await _datasource.updateStock(stock: StockModel.fromStock(stock)));
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> duplicateStockWithoutProperties(
      {required String stockID, required Provider newProvider}) async {
    try {
      var stock = await _datasource.getStockById(id: stockID);

      stock.product.provider = newProvider;
      stock.code = StockHelper.getStockCode(
          product: stock.product, date: stock.registrationDate);

      var stockByCodeFromDB =
          await _datasource.getStockByCode(code: stock.code);

      if (stockByCodeFromDB != null) {
        return Right(stockByCodeFromDB);
      } else {
        stock.total = 0;
        stock.totalOrdered = 0;
        return Right(await _datasource.createStock(stock: stock));
      }
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<StockError, Stock>> moveStockWithProperties(
      {required String stockID, required Provider newProvider}) async {
    try {
      var stock = await _datasource.getStockById(id: stockID);

      final actualProvider = ProviderModel.fromProvider(stock.product.provider);

      if (newProvider == actualProvider) {
        return Left(
            StockError('Selected provider are equal then the actual provider'));
      }

      stock.product.provider = newProvider;
      stock.code = StockHelper.getStockCode(
          product: stock.product, date: stock.registrationDate);

      var stockByCodeFromDB =
          await _datasource.getStockByCode(code: stock.code);

      if (stockByCodeFromDB != null) {
        stockByCodeFromDB.total += stock.total;
        stockByCodeFromDB.totalOrdered += stock.totalOrdered;
        await _datasource.deleteStock(stock: stock);
        return Right(await _datasource.updateStock(stock: stockByCodeFromDB));
      } else {
        return Right(await _datasource.updateStock(stock: stock));
      }
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(StockError('Erro interno no servidor'));
    } on StockError catch (e) {
      return Left(e);
    }
  }
}
