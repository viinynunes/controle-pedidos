import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:controle_pedidos/src/modules/stock/infra/repositories/new_stock_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/product_mock.dart';
import '../../../../domain/entities/stock_mock.dart';
import '../../external/mocks/mock_datasource.mocks.dart';

main() {
  final datasource = MockINewStockDatasource();
  final repository = NewStockRepositoryImpl(datasource);
  final product = ProductMock.getOneProduct();
  final date = DateTime.now();
  const stockID = 'stockID01';
  String stockCode = product.id +
      product.provider.id +
      DateTime(date.year, date.month, date.day).toString();
  const stockTotal = 1;
  const stockTotalOrdered = 1;
  const stockTotalFromCode = 2;
  const stockTotalOrderedFromCode = 3;
  const increaseQuantity = 1;
  const decreaseQuantity = 1;
  final defaultStock =
      StockMock.getOneStock(id: stockID, code: stockCode, total: stockTotal);

  setUp(() {
    when(datasource.getStockById(id: anyNamed('id'))).thenAnswer((_) async =>
        StockMock.getOneStock(
            id: stockID,
            code: stockCode,
            total: stockTotal,
            totalOrdered: stockTotalOrdered));

    when(datasource.getStockByCode(code: anyNamed('code'))).thenAnswer(
        (_) async => StockMock.getOneStock(
            code: stockCode,
            total: stockTotalFromCode,
            totalOrdered: stockTotalOrderedFromCode));

    when(datasource.deleteStock(stock: defaultStock)).thenAnswer(
        (Invocation invocation) async =>
            invocation.namedArguments[const Symbol('stock')]);

    when(datasource.createStock(
            stock: defaultStock, stockID: anyNamed('stockID')))
        .thenAnswer((Invocation invocation) async =>
            invocation.namedArguments[const Symbol('stock')]);

    when(datasource.updateStock(stock: defaultStock)).thenAnswer(
        (Invocation invocation) async =>
            invocation.namedArguments[const Symbol('stock')]);
  });

  group('tests to change stock date in repository', () {
    test('have to catch an exception when getStockById don\'t found a stock',
        () async {
      when(datasource.getStockById(id: anyNamed('id')))
          .thenThrow(() => throw StockError('Stock not found'));

      final result =
          await repository.changeStockDate(stockId: stockID, newDate: date);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to catch an exception when delete stock fail', () async {
      when(datasource.deleteStock(stock: defaultStock))
          .thenThrow(() => throw StockError('Delete Stock Fail'));

      final result =
          await repository.changeStockDate(stockId: stockID, newDate: date);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to catch an exception when create stock fail', () async {
      when(datasource.createStock(
              stock: defaultStock, stockID: anyNamed('stockID')))
          .thenThrow(() => throw StockError('Create Stock Fail'));

      when(datasource.getStockByCode(code: anyNamed('code')))
          .thenAnswer((_) async => null);

      final result =
          await repository.changeStockDate(stockId: stockID, newDate: date);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to catch an exception when update stock fail', () async {
      when(datasource.updateStock(stock: defaultStock))
          .thenThrow(() => throw StockError('Delete Stock Fail'));

      final result =
          await repository.changeStockDate(stockId: stockID, newDate: date);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to create a new stock when getStockByCode return null',
        () async {
      when(datasource.getStockByCode(code: anyNamed('code')))
          .thenAnswer((_) async => null);

      final result = await repository.changeStockDate(
          stockId: stockID, newDate: date.add(const Duration(days: 1)));

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total), stockTotal);
      expect(
          result.fold((l) => null, (r) => r.totalOrdered), stockTotalOrdered);
    });

    test('have to update the stock when getStockByCode return a stock from DB',
        () async {
      when(datasource.getStockByCode(code: anyNamed('code'))).thenAnswer(
          (_) async => StockMock.getOneStock(
              total: stockTotalFromCode,
              totalOrdered: stockTotalOrderedFromCode));

      final result = await repository.changeStockDate(
          stockId: stockID, newDate: date.add(const Duration(days: 1)));

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total),
          stockTotal + stockTotalFromCode);
      expect(result.fold((l) => null, (r) => r.totalOrdered),
          stockTotal + stockTotalOrderedFromCode);
    });
  });

  group('tests to decrease total from Stock in repository', () {
    test(
        'have to catch an exception when delete stock fail in decreaseTotalFromStock',
        () async {
      when(datasource.deleteStock(stock: defaultStock))
          .thenThrow(() => throw StockError('Delete Stock Fail'));

      when(datasource.getStockByCode(code: anyNamed('code')))
          .thenAnswer((_) async => StockMock.getOneStock(totalOrdered: 0));

      final result = await repository.decreaseTotalFromStock(
          product: product, date: date, decreaseQuantity: 2);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test(
        'have to catch an exception when update stock fail in decreaseTotalFromStock',
        () async {
      when(datasource.updateStock(stock: defaultStock))
          .thenThrow(() => throw StockError('Update Stock Fail'));

      final result = await repository.decreaseTotalFromStock(
          product: product, date: date, decreaseQuantity: decreaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test(
        'have to catch an exception when getStockByCode fail in decreaseTotalFromStock',
        () async {
      when(datasource.getStockByCode(code: anyNamed('code')))
          .thenThrow(() => throw StockError('getStockByCode Fail'));

      final result = await repository.decreaseTotalFromStock(
          product: product, date: date, decreaseQuantity: decreaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test(
        'have to decrease stock total from DB and update stock got on getStockByCode',
        () async {
      final result = await repository.decreaseTotalFromStock(
          product: product, date: date, decreaseQuantity: decreaseQuantity);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total),
          stockTotalFromCode - decreaseQuantity);
    });

    test(
        'have to decrease stock total from DB and delete stock got on getStockByCode when total and total ordered is 0',
        () async {
      when(datasource.getStockByCode(code: anyNamed('code'))).thenAnswer(
          (_) async => StockMock.getOneStock(total: 2, totalOrdered: 0));

      final result = await repository.decreaseTotalFromStock(
          product: product, date: date, decreaseQuantity: 2);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total), 0);
      expect(result.fold((l) => null, (r) => r.totalOrdered), 0);
    });
  });

  group('tests to decrease total ordered from Stock in repository', () {
    test('have to return a Left with an Exception when Get Stock By ID fail',
        () async {
      when(datasource.getStockById(id: anyNamed('id')))
          .thenThrow(() => throw Exception('Get Stock By ID Error'));

      final result = await repository.decreaseTotalOrderedFromStock(
          stockID: stockID, decreaseQuantity: decreaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to return a Left with an Exception when update fail', () async {
      when(datasource.updateStock(stock: defaultStock))
          .thenThrow(() => throw Exception('Update Stock Error'));

      final result = await repository.decreaseTotalOrderedFromStock(
          stockID: stockID, decreaseQuantity: decreaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to decrease stock total ordered and update stock', () async {
      final result = await repository.decreaseTotalOrderedFromStock(
          stockID: stockID, decreaseQuantity: decreaseQuantity);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total), stockTotal);
      expect(result.fold((l) => null, (r) => r.totalOrdered),
          stockTotalOrdered - decreaseQuantity);
    });
  });

  group('tests to delete stock in repository', () {
    test('have to return a Left with an Exception when delete stock fail',
        () async {
      when(datasource.deleteStock(stock: defaultStock))
          .thenThrow(() => throw Exception('Delete Error'));

      final result = await repository.deleteStock(defaultStock);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to return a Right with deleted stock', () async {
      final result = await repository.deleteStock(defaultStock);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
    });
  });

  group('tests to increase Total From Stock in repository', () {
    test(
        'have to catch an exception when create stock fail in increase total from stock',
        () async {
      when(datasource.createStock(stock: defaultStock))
          .thenThrow(() => throw StockError('Delete Stock Fail'));

      when(datasource.getStockByCode(code: anyNamed('code')))
          .thenAnswer((_) async => null);

      final result = await repository.increaseTotalFromStock(
          product: product, date: date, increaseQuantity: 2);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to catch an exception when update stock fail', () async {
      when(datasource.updateStock(stock: defaultStock))
          .thenThrow(() => throw StockError('Update Stock Fail'));

      final result = await repository.increaseTotalFromStock(
          product: product, date: date, increaseQuantity: increaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to catch an exception when getStockByCode fail', () async {
      when(datasource.getStockByCode(code: anyNamed('code')))
          .thenThrow(() => throw StockError('getStockByCode Fail'));

      final result = await repository.increaseTotalFromStock(
          product: product, date: date, increaseQuantity: increaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to create a new stock if getStockByCode return null', () async {
      when(datasource.getStockByCode(code: anyNamed('code')))
          .thenAnswer((_) async => null);

      final result = await repository.increaseTotalFromStock(
          product: product, date: date, increaseQuantity: increaseQuantity);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total), increaseQuantity);
    });

    test(
        'have to increase stock total from DB and update stock got on getStockByCode',
        () async {
      final result = await repository.increaseTotalFromStock(
          product: product, date: date, increaseQuantity: increaseQuantity);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total),
          stockTotalFromCode + increaseQuantity);
    });
  });

  group('tests to increase total ordered from Stock in repository', () {
    test(
        'have to return a Left with an Exception when Get Stock By ID fail in increase total ordered',
        () async {
      when(datasource.getStockById(id: anyNamed('id')))
          .thenThrow(() => throw Exception('Get Stock By ID Error'));

      final result = await repository.increaseTotalOrderedFromStock(
          stockID: stockID, increaseQuantity: increaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test(
        'have to return a Left with an Exception when update fail in increase total ordered',
        () async {
      when(datasource.updateStock(stock: defaultStock))
          .thenThrow(() => throw Exception('Update Stock Error'));

      final result = await repository.increaseTotalOrderedFromStock(
          stockID: stockID, increaseQuantity: increaseQuantity);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to increase stock total ordered and update stock', () async {
      final result = await repository.increaseTotalOrderedFromStock(
          stockID: stockID, increaseQuantity: increaseQuantity);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
      expect(result.fold((l) => null, (r) => r.total), stockTotal);
      expect(result.fold((l) => null, (r) => r.totalOrdered),
          stockTotalOrdered + increaseQuantity);
    });
  });

  group('tests to update stock in repository', () {
    test('have to return a Left with an Exception when update stock fail',
        () async {
      when(datasource.updateStock(stock: defaultStock))
          .thenThrow(() => throw Exception('Update Error'));

      final result = await repository.updateStock(defaultStock);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<Exception>());
    });

    test('have to return a Right with update stock', () async {
      final result = await repository.updateStock(defaultStock);

      expect(result, isA<Right>());
      expect(result.fold(id, id), isA<Stock>());
    });
  });
}
