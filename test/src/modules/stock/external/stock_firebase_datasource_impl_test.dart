import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/external/helper/stock_firebase_helper.dart';
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

  setUp(() {
    firebase = null;
    firebase = FakeFirebaseFirestore();

    stockCollection = null;

    stockCollection =
        firebase!.collection('company').doc(mockCompanyID).collection('stock');

    datasource = NewStockFirebaseDatasourceImpl(
        firebase: firebase!,
        helper: StockFirebaseHelper(stockCollection!),
        companyID: mockCompanyID);

    firebase!.collection('company').doc(mockCompanyID).delete();
  });

  group('Tests to increase stock total', () {
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

      var stock = StockMock.getOneStock(total: stockTotalIntoDB, totalOrdered: 0);
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
}
