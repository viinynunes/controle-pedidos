import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/increase_stock_total_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/product_mock.dart';
import '../../../../domain/entities/stock_mock.dart';
import '../i_new_stock_usecase_test.mocks.dart';

@GenerateMocks([INewStockRepository])
main() {
  final repository = MockINewStockRepository();
  final increaseTotal = IncreaseStockTotalUsecaseImpl(repository);
  final date = DateTime.now();
  final product = ProductMock.getOneProduct();
  const increaseQuantity = 1;

  setUp(() {
    when(repository.increaseTotalFromStock(
            product: product, date: date, increaseQuantity: increaseQuantity))
        .thenAnswer((realInvocation) async => Right(StockMock.getOneStock()));
  });

  test('have to return a Stock Error when product ID is empty', () async {
    final result = await increaseTotal(
        product: ProductMock.getOneProduct(productID: ''),
        date: DateTime.now(),
        increaseQuantity: 1);

    expect(result.fold(id, id), isA<StockError>());
  });

  test(
      'have to return a Stock Error when increaseQuantity is not a positive number',
      () async {
    var result = await increaseTotal(
        product: ProductMock.getOneProduct(productID: ''),
        date: DateTime.now(),
        increaseQuantity: 0);

    expect(result.fold(id, id), isA<StockError>());

    result = await increaseTotal(
        product: ProductMock.getOneProduct(productID: ''),
        date: DateTime.now(),
        increaseQuantity: -1);

    expect(result.fold(id, id), isA<StockError>());
  });

  test('have to return a stock from repository', () async {
    final result = await increaseTotal(
        product: product, date: date, increaseQuantity: increaseQuantity);

    expect(result.fold(id, id), isA<Stock>());
  });
}
