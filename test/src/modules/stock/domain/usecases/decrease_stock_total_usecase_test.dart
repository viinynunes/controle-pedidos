import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/decrease_stock_total_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/product_mock.dart';
import '../../../../domain/entities/stock_mock.dart';
import '../repositories/mock_repository.mocks.dart';

main() {
  final repository = MockINewStockRepository();
  final decreaseTotal = DecreaseStockTotalUsecaseImpl(repository);
  const decreaseQuantity = 1;

  late ProductModel product;
  final date = DateTime.now();

  setUp(() {
    product = ProductMock.getOneProduct();

    when(repository.decreaseTotalFromStock(
            product: product, date: date, decreaseQuantity: decreaseQuantity))
        .thenAnswer((_) async => Right(StockMock.getOneStock()));
  });

  test('have to return a Left when product id is empty', () async {
    product.id = '';

    final result = await decreaseTotal(
        product: product, date: date, decreaseQuantity: decreaseQuantity);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
  });

  test('have to return a Left when decrease quantity is a non positive number',
      () async {
    var result =
        await decreaseTotal(product: product, date: date, decreaseQuantity: 0);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());

    result = await decreaseTotal(
        product: product, date: date, decreaseQuantity: -10);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
  });

  test('have to return a stock from repository when everything is correct',
      () async {
    final result = await decreaseTotal(
        product: product, date: date, decreaseQuantity: decreaseQuantity);

    expect(result, isA<Right>());
    expect(result.fold(id, id), isA<Stock>());
  });
}
