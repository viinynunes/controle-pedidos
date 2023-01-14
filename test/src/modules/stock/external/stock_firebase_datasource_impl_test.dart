import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/establish_model.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/external/helper/stock_firebase_helper.dart';
import 'package:controle_pedidos/src/modules/stock/external/new_stock_firebase_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/stock/infra/datasources/i_new_stock_datasource.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final firebase = FakeFirebaseFirestore();

  late INewStockDatasource datasource;
  late CollectionReference stockCollection;
  late StockModel stock;

  const mockCompanyID = 'mockCompanyID';

  setUp(() {
    stockCollection =
        firebase.collection('company').doc(mockCompanyID).collection('stock');

    datasource = NewStockFirebaseDatasourceImpl(
        firebase: firebase,
        helper: StockFirebaseHelper(stockCollection),
        companyID: mockCompanyID);

    stock = StockModel(
        id: '0',
        code: '0',
        total: 1,
        totalOrdered: 0,
        registrationDate: DateTime.now(),
        product: ProductModel(
            id: '3',
            name: 'raphis',
            category: 'vs',
            enabled: true,
            stockDefault: false,
            provider: ProviderModel(
                id: '4',
                name: 'Odair',
                location: 'Box G58',
                registrationDate: DateTime.now(),
                enabled: true,
                establishment: EstablishmentModel(
                    id: '5',
                    name: 'Ceaflor',
                    registrationDate: DateTime.now(),
                    enabled: true))));

    firebase.collection('company').doc(mockCompanyID).delete();
  });

  _setStockCode(StockModel stock) {
    stock.code = stock.product.id +
        stock.product.provider.id +
        DateTime(stock.registrationDate.year, stock.registrationDate.month,
                stock.registrationDate.day)
            .toString();
  }

  _insertStockIntoDB({int total = 0, int totalOrdered = 0}) {
    _setStockCode(stock);
    stock.total = total;
    stock.totalOrdered = totalOrdered;

    stockCollection.add(stock.toMap());
  }

  group('Tests to increase stock total', () {
    test(
      'increase function have to create a new stock if it does not exists',
      () async {
        final result = await datasource.increaseTotalFromStock(
            product: ProductModel.fromProduct(product: stock.product),
            date: stock.registrationDate,
            increaseQuantity: 1);

        expect(result, isA<StockModel>());
        expect(result.total, equals(stock.total));
      },
    );

    test(
      'increase function have to sum the total if an stock already exists in db',
      () async {
        _setStockCode(stock);
        const stockTotalIntoDB = 4;
        const increaseQuantity = 6;

        int summedTotal = increaseQuantity + stockTotalIntoDB;

        _insertStockIntoDB(total: stockTotalIntoDB);

        expect(true, true);

        final result = await datasource.increaseTotalFromStock(
            product: ProductModel.fromProduct(product: stock.product),
            date: stock.registrationDate,
            increaseQuantity: increaseQuantity);

        expect(result, isA<StockModel>());
        expect(result.total, equals(summedTotal));
      },
    );
  });

  group('Tests to decrease total from stock', () {
    test('decrease function have to decrease value from DB', () async {
      const stockTotalIntoDB = 100;
      const decreaseQuantity = 37;

      const decreasedTotal = stockTotalIntoDB - decreaseQuantity;

      _insertStockIntoDB(total: stockTotalIntoDB);

      final result = await datasource.decreaseTotalFromStock(
          product: ProductModel.fromProduct(product: stock.product),
          date: stock.registrationDate,
          decreaseQuantity: decreaseQuantity);

      expect(result.total, equals(decreasedTotal));
    });

    test(
        'decrease function have to delete stock from DB when total and total ordered are equal zero',
        () async {
      const stockTotalIntoDB = 15;
      const decreaseQuantity = 15;

      const decreasedTotal = stockTotalIntoDB - decreaseQuantity;

      _insertStockIntoDB(total: stockTotalIntoDB);

      final result = await datasource.decreaseTotalFromStock(
          product: ProductModel.fromProduct(product: stock.product),
          date: stock.registrationDate,
          decreaseQuantity: decreaseQuantity,
          deleteIfEmpty: true);

      expect(result.total, equals(decreasedTotal));

      final deleted = await stockCollection.doc(result.id).get();

      expect(deleted.exists, false);
    });

    test(
        'decrease function do not have to delete stock from DB when total are zero but total ordered are other number',
        () async {
      const stockTotalIntoDB = 15;
      const decreaseQuantity = 13;

      const decreasedTotal = stockTotalIntoDB - decreaseQuantity;

      _insertStockIntoDB(total: stockTotalIntoDB);

      final result = await datasource.decreaseTotalFromStock(
          product: ProductModel.fromProduct(product: stock.product),
          date: stock.registrationDate,
          decreaseQuantity: decreaseQuantity,
          deleteIfEmpty: true);

      expect(result.total, equals(decreasedTotal));

      final documentNotDeleted = await stockCollection.doc(result.id).get();

      expect(documentNotDeleted.exists, true);
    });
  });
}
