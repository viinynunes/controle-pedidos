import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:controle_pedidos/src/modules/stock/infra/datasources/i_new_stock_datasource.dart';
import 'package:dartz/dartz.dart';

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
      stock.code =
          _getStockCode(product: stock.product, date: stock.registrationDate);

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
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Stock>> decreaseTotalFromStock(
      {required Product product,
      required DateTime date,
      required int decreaseQuantity}) async {
    try {
      var stock = _getNewStock(product: product, date: date);

      final stockFromDB = await _datasource.getStockByCode(code: stock.code);

      if (stockFromDB == null) {
        throw StockError('Stock não encontrado - CODE ${stock.code}');
      }

      stockFromDB.total -= decreaseQuantity;

      return stockFromDB.total == 0 && stockFromDB.totalOrdered == 0
          ? Right(await _datasource.deleteStock(stock: stockFromDB))
          : Right(await _datasource.updateStock(stock: stockFromDB));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Stock>> decreaseTotalOrderedFromStock(
      {required String stockID, required int decreaseQuantity}) async {
    try {
      var stock = await _datasource.getStockById(id: stockID);

      stock.totalOrdered -= decreaseQuantity;

      return Right(await _datasource.updateStock(stock: stock));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Stock>> deleteStock(Stock stock) async {
    try {
      return Right(
          await _datasource.deleteStock(stock: StockModel.fromStock(stock)));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Set<Provider>>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) async {
    try {
      _removeHourFromDateTime(date: iniDate);
      _removeHourFromDateTime(date: endDate);

      return Right(await _datasource.getProviderListByStockBetweenDates(
          iniDate: iniDate, endDate: endDate));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) async {
    try {
      _removeHourFromDateTime(date: iniDate);
      _removeHourFromDateTime(date: endDate);

      final list = await _datasource.getStockListBetweenDates(
          iniDate: iniDate, endDate: endDate);

      return Right(_mergeStockList(stockListFromDB: list));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, List<Stock>>> getStockListByProviderBetweenDates(
      {required Provider provider,
      required DateTime iniDate,
      required DateTime endDate}) async {
    try {
      _removeHourFromDateTime(date: iniDate);
      _removeHourFromDateTime(date: endDate);

      final list = await _datasource.getStockListByProviderBetweenDates(
          provider: ProviderModel.fromProvider(provider),
          iniDate: iniDate,
          endDate: endDate);

      return Right(_mergeStockList(stockListFromDB: list));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Stock>> increaseTotalFromStock(
      {required Product product,
      required DateTime date,
      required int increaseQuantity}) async {
    try {
      final stock = _getNewStock(
        product: ProductModel.fromProduct(product: product),
        date: date,
      );

      final stockFromDB = await _datasource.getStockByCode(code: stock.code);

      if (stockFromDB != null) {
        stockFromDB.total += increaseQuantity;
        return Right(await _datasource.updateStock(
            stock: StockModel.fromStock(stockFromDB)));
      } else {
        return Right(
            await _datasource.createStock(stock: StockModel.fromStock(stock)));
      }
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Stock>> increaseTotalOrderedFromStock(
      {required String stockID, required int increaseQuantity}) async {
    try {
      var stock = await _datasource.getStockById(id: stockID);

      stock.totalOrdered += increaseQuantity;

      return Right(await _datasource.updateStock(stock: stock));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  @override
  Future<Either<StockError, Stock>> updateStock(Stock stock) async {
    try {
      return Right(
          await _datasource.updateStock(stock: StockModel.fromStock(stock)));
    } on StockError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(StockError(e.toString()));
    }
  }

  StockModel _getNewStock({required Product product, required DateTime date}) {
    return StockModel(
        id: '0',
        code: _getStockCode(product: product, date: date),
        total: 0,
        totalOrdered: 0,
        registrationDate: date,
        product: product);
  }

  String _getStockCode({required Product product, required DateTime date}) {
    return product.id +
        product.provider.id +
        DateTime(date.year, date.month, date.day).toString();
  }

  _removeHourFromDateTime({required DateTime date}) {
    date = DateTime(date.year, date.month, date.day);
  }

  _mergeStockList({required List<StockModel> stockListFromDB}) {
    List<StockModel> stockList = [];

    for (var stock in stockListFromDB) {
      if (stockList.contains(stock)) {
        var stockFromList = stockListFromDB.singleWhere(
            (stockFromList) => stockFromList.product == stock.product);

        stockFromList.total += stock.total;
        stockFromList.totalOrdered += stock.totalOrdered;
      } else {
        stockListFromDB.add(stock);
      }
    }

    return stockList;
  }
}
