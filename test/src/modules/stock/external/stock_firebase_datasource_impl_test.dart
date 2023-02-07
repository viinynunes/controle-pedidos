import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/external/new_stock_firebase_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/stock/infra/datasources/i_new_stock_datasource.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../domain/entities/stock_mock.dart';

main() {
  late FirebaseFirestore? firebase;
  late CollectionReference? stockCollection;

  late INewStockDatasource datasource;

  const mockCompanyID = 'mockCompanyID';
  final date = DateTime.now();
  final defaultStock = StockMock.getOneStock(
      registrationDate: DateTime(date.year, date.month, date.day));

  setUp(() {
    firebase = null;
    firebase = FakeFirebaseFirestore();

    stockCollection = null;
    stockCollection =
        firebase!.collection('company').doc(mockCompanyID).collection('stock');

    datasource = NewStockFirebaseDatasourceImpl(
        firebase: firebase!, companyID: mockCompanyID);

    firebase!.collection('company').doc(mockCompanyID).delete();
  });

  group('tests to getProviderListByStockBetweenDates', () {
    test('have to return a stock list with 1 stock', () async {
      await datasource.createStock(stock: defaultStock);
      final iniDate = DateTime(date.year, date.month, date.day);
      final endDate = DateTime(date.year, date.month, date.day);

      final result = await datasource.getProviderListByStockBetweenDates(
          iniDate: iniDate, endDate: endDate);

      expect(result, isA<Set<ProviderModel>>());
      expect(result.length, 1);
    });
  });

  group('tests to getStockListByProviderBetweenDates', () {
    test('have to return a stock list with 1 stock from getStockListByProviderBetweenDates', () async {
      await datasource.createStock(stock: defaultStock);
      final iniDate = DateTime(date.year, date.month, date.day);
      final endDate = DateTime(date.year, date.month, date.day);

      final result = await datasource.getStockListByProviderBetweenDates(
          provider: ProviderModel.fromProvider(defaultStock.product.provider),
          iniDate: iniDate,
          endDate: endDate);

      expect(result, isA<List<StockModel>>());
      expect(result.length, 1);
    });
  });

/*  group('Tests to increase stock total', () {
    test(
      'increase function have to create a new stock if it does not exists',
      () async {
        const stockTotal = 1;
        final stock = StockMock.getOneStock(total: stockTotal);

        final result = await datasource.increaseTotalFromStock(
            product: ProductModel.fromProduct(product: stock.product),
            date: stock.registrationDate,
            increaseQuantity: stockTotal);

        final stockSnap =
            await stockCollection!.where('code', isEqualTo: stock.code).get();

        final createdStock =
            StockModel.fromDocumentSnapshot(stockSnap.docs.first);

        expect(stockSnap.docs.length, 1);
        expect(result, isA<StockModel>());
        expect(result.total, stock.total);
        expect(createdStock.total, stock.total);
      },
    );

    test(
      'increase function have to sum the total if an stock already exists in db',
      () async {
        const stockTotalIntoDB = 4;
        const increaseQuantity = 6;
        int summedTotal = increaseQuantity + stockTotalIntoDB;

        var stock = StockMock.getOneStock(total: stockTotalIntoDB);
        await stockCollection!.add(stock.toMap());

        final result = await datasource.increaseTotalFromStock(
            product: ProductModel.fromProduct(product: stock.product),
            date: stock.registrationDate,
            increaseQuantity: increaseQuantity);

        expect(result, isA<StockModel>());
        expect(result.total, summedTotal);
      },
    );
  });

  group('Tests to decrease total from stock', () {
    test('decrease function have to decrease value from DB', () async {
      const stockTotalIntoDB = 100;
      const decreaseQuantity = 37;
      const decreasedTotal = stockTotalIntoDB - decreaseQuantity;

      var stock = StockMock.getOneStock(total: stockTotalIntoDB);
      await stockCollection!.add(stock.toMap());

      final result = await datasource.decreaseTotalFromStock(
          product: ProductModel.fromProduct(product: stock.product),
          date: stock.registrationDate,
          decreaseQuantity: decreaseQuantity);

      expect(result.total, decreasedTotal);
    });

    test(
        'decrease function have to delete stock from DB when total and total ordered are equal zero',
        () async {
      const stockTotalIntoDB = 15;
      const decreaseQuantity = 15;

      const decreasedTotal = stockTotalIntoDB - decreaseQuantity;

      var stock =
          StockMock.getOneStock(total: stockTotalIntoDB, totalOrdered: 0);
      await stockCollection!.add(stock.toMap());

      final result = await datasource.decreaseTotalFromStock(
          product: ProductModel.fromProduct(product: stock.product),
          date: stock.registrationDate,
          decreaseQuantity: decreaseQuantity,
          deleteIfEmpty: true);

      expect(result.total, decreasedTotal);

      final deleted = await stockCollection!.doc(result.id).get();

      expect(deleted.exists, false);
    });

    test(
        'decrease function do not have to delete stock from DB when total are zero but total ordered are other number',
        () async {
      const stockTotalIntoDB = 15;
      const decreaseQuantity = 13;

      const decreasedTotal = stockTotalIntoDB - decreaseQuantity;

      var stock = StockMock.getOneStock(total: stockTotalIntoDB);
      await stockCollection!.add(stock.toMap());

      final result = await datasource.decreaseTotalFromStock(
          product: ProductModel.fromProduct(product: stock.product),
          date: stock.registrationDate,
          decreaseQuantity: decreaseQuantity,
          deleteIfEmpty: true);

      expect(result.total, equals(decreasedTotal));

      final documentNotDeleted = await stockCollection!.doc(result.id).get();

      expect(documentNotDeleted.exists, true);
    });
  });

  group('tests to decrease total ordered from stock', () {
    test(
        'hate to throw a Stock Error Exception when stock id is not found on decreaseTotalOrderedFromStock',
        () async {
      var stock = StockMock.getOneStock(total: 0, totalOrdered: 1);
      await stockCollection!.add(stock.toMap());

      expect(
          () async => await datasource.decreaseTotalOrderedFromStock(
              stockID: stock.id, decreaseQuantity: 1),
          throwsA(isA<StockError>()));
    });

    test('have to decrease total ordered on db', () async {
      const decreaseQuantity = 3;
      const stockTotalOrderedOnDB = 10;
      const summedTotalOrdered = stockTotalOrderedOnDB - decreaseQuantity;

      ///insert data on db
      var stock =
          StockMock.getOneStock(total: 0, totalOrdered: stockTotalOrderedOnDB);
      final result = await stockCollection!.add(stock.toMap());
      stock.id = result.id;

      ///decreasing quantity on db
      final decreasedStock = await datasource.decreaseTotalOrderedFromStock(
          stockID: stock.id, decreaseQuantity: decreaseQuantity);

      expect(decreasedStock.totalOrdered, summedTotalOrdered);
    });
  });

  group('tests to increase total ordered from stock', () {
    test(
        'have to throw a Stock Error Exception when stock id is not found on increaseTotalOrderedFromStock',
        () async {
      var stock = StockMock.getOneStock(total: 0, totalOrdered: 1);
      await stockCollection!.add(stock.toMap());

      expect(
          () async => await datasource.increaseTotalOrderedFromStock(
              stockID: stock.id, increaseQuantity: 50),
          throwsA(isA<StockError>()));
    });

    test('have to increase total ordered on db', () async {
      const increaseQuantity = 3;
      const stockTotalOrderedOnDB = 10;
      const summedTotalOrdered = stockTotalOrderedOnDB + increaseQuantity;

      ///insert data on db
      var stock =
          StockMock.getOneStock(total: 0, totalOrdered: stockTotalOrderedOnDB);
      final result = await stockCollection!.add(stock.toMap());
      stock.id = result.id;

      ///decreasing quantity on db
      final increasedStock = await datasource.increaseTotalOrderedFromStock(
          stockID: stock.id, increaseQuantity: increaseQuantity);

      expect(increasedStock.totalOrdered, summedTotalOrdered);
    });
  });

  group('tests to change stock date', () {
    test(
        'have to create a new stock when theres no other stock with the same code into the new date',
        () async {
      const stockTotalOrderedOnDB = 10;
      const stockTotalOnDB = 10;

      ///insert data on db
      var stock = StockMock.getOneStock(
          total: stockTotalOnDB, totalOrdered: stockTotalOrderedOnDB);
      final result = await stockCollection!.add(stock.toMap());
      stock.id = result.id;

      final now = DateTime.now();
      final changedStockResult = await datasource.changeStockDate(
          stockId: stock.id,
          newDate: DateTime(now.year, now.month, now.day + 1));

      expect(changedStockResult.id, stock.id);

      final resultSnap = await stockCollection!.doc(stock.id).get();
      expect(resultSnap.exists, true);

      final changedStock = StockModel.fromDocumentSnapshot(resultSnap);

      expect(changedStock.registrationDate,
          DateTime(now.year, now.month, now.day + 1));
      expect(changedStock.total, stockTotalOnDB);
      expect(changedStock.totalOrdered, stockTotalOrderedOnDB);
    });

    test('have to update a stock with the same code into new selected date',
        () async {
      const stockTotalOrderedOnDB = 10;
      const stockTotalOnDB = 10;

      const toModifyStockTotalOrdered = 10;
      const toModifyStockTotal = 10;

      const summedTotal = stockTotalOnDB + toModifyStockTotal;
      const summedTotalOrdered =
          stockTotalOrderedOnDB + toModifyStockTotalOrdered;

      final now = DateTime.now();
      final newDate = DateTime(now.year, now.month, now.day + 1);

      ///insert stock into new date
      var stockOnDb = StockMock.getOneStock(
          total: stockTotalOnDB,
          totalOrdered: stockTotalOrderedOnDB,
          registrationDate: newDate);

      final value = await stockCollection!.add(stockOnDb.toMap());
      stockOnDb.id = value.id;

      ///insert to modify stock on db
      var toModifyStock = StockMock.getOneStock(
          total: toModifyStockTotalOrdered, totalOrdered: toModifyStockTotal);
      final result = await stockCollection!.add(toModifyStock.toMap());
      toModifyStock.id = result.id;

      var stockSnap = await stockCollection!.get();

      expect(stockSnap.docs.length, 2);

      final changedStockResult = await datasource.changeStockDate(
          stockId: toModifyStock.id, newDate: newDate);

      expect(changedStockResult.id, stockOnDb.id);
      expect(changedStockResult.total, summedTotal);
      expect(changedStockResult.totalOrdered, summedTotalOrdered);

      stockSnap = await stockCollection!.get();
      expect(stockSnap.docs.length, 1);
    });
  });*/
}
