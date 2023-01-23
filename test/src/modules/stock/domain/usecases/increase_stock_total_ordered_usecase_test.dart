import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/increase_stock_total_ordered_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/stock_mock.dart';
import '../repositories/mock_repository.mocks.dart';

main() {
  final repository = MockINewStockRepository();
  final increaseTotalOrdered = IncreaseStockTotalOrderedUsecaseImpl(repository);

  const stockID = 'stockID01';
  const increaseQuantity = 1;

  setUp(() {
    when(repository.increaseTotalOrderedFromStock(
            stockID: stockID, increaseQuantity: increaseQuantity))
        .thenAnswer((realInvocation) async => Right(StockMock.getOneStock()));
  });

  test('have to return a Left with a Stock Error when StockID is Empty',
      () async {
    final result = await increaseTotalOrdered(
        stockID: '', increaseQuantity: increaseQuantity);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
  });

  test(
      'have to return a Left with a Stock Error when decrease quantity is a non positive number',
      () async {
    var result =
        await increaseTotalOrdered(stockID: stockID, increaseQuantity: 0);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());

    result =
        await increaseTotalOrdered(stockID: stockID, increaseQuantity: -33);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
  });

  test(
      'have to return a Right with a Stock when everything is correct increasing total ordered',
      () async {
    final result = await increaseTotalOrdered(
        stockID: stockID, increaseQuantity: increaseQuantity);

    expect(result, isA<Right>());
    expect(result.fold(id, id), isA<Stock>());
  });
}
