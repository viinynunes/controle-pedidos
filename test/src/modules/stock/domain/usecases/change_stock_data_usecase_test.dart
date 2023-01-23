import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/change_stock_date_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/stock_mock.dart';
import '../repositories/mock_repository.mocks.dart';

main() {
  final repository = MockINewStockRepository();
  final changeStockDate = ChangeStockDateUsecaseImpl(repository);
  final date = DateTime.now().add(const Duration(days: 2));

  setUp(() {
    when(repository.changeStockDate(
            stockId: anyNamed('stockId'), newDate: date))
        .thenAnswer((invocation) async => Right(StockMock.getOneStock(
            id: invocation.namedArguments[const Symbol('stockId')],
            registrationDate: date)));
  });

  test(
      'have to return a Left with a stock error when stock ID is empty on changeStockDate',
      () async {
    final result = await changeStockDate(stockId: '', newDate: date);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
    expect(
        result.fold((l) => l.message, (r) => null), 'Stock ID cannot be empty');
  });

  test('have to return a Right with a stock from repository on changeStockDate',
      () async {
    final result = await changeStockDate(stockId: 'stockID', newDate: date);

    expect(result, isA<Right>());
    expect(result.fold(id, id), isA<Stock>());
  });
}
