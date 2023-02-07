import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/decrease_stock_total_ordered_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/stock_mock.dart';
import '../repositories/mock_repository.mocks.dart';

main() {
  final repository = MockINewStockRepository();
  final decreaseTotalOrdered = DecreaseStockTotalOrderedUsecaseImpl(repository);

  const stockID = 'stockID01';
  const decreaseQuantity = 1;

  setUp(() {
    when(repository.decreaseTotalOrderedFromStock(
            stockID: stockID, decreaseQuantity: decreaseQuantity))
        .thenAnswer((realInvocation) async => Right(StockMock.getOneStock()));
  });

  test('have to return a Left with a Stock Error when StockID is Empty',
      () async {
    final result = await decreaseTotalOrdered(
        stockID: '', decreaseQuantity: decreaseQuantity);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
  });

  test(
      'have to return a Left with a Stock Error when decrease quantity is a non positive number',
      () async {
    var result =
        await decreaseTotalOrdered(stockID: stockID, decreaseQuantity: 0);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());

    result =
        await decreaseTotalOrdered(stockID: stockID, decreaseQuantity: -33);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
  });

  test(
      'have to return a Right with a Stock when everything is correct increasing total ordered',
      () async {
    final result = await decreaseTotalOrdered(
        stockID: stockID, decreaseQuantity: decreaseQuantity);

    expect(result, isA<Right>());
    expect(result.fold(id, id), isA<Stock>());
  });
}
