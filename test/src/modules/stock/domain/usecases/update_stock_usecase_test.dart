import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/update_stock_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/stock_mock.dart';
import '../repositories/mock_repository.mocks.dart';

main() {
  final repository = MockINewStockRepository();
  final updateStock = UpdateStockUsecaseImpl(repository);
  late StockModel stock;

  setUp(() {
    stock = StockMock.getOneStock();

    when(repository.updateStock(stock)).thenAnswer(
        (invocation) async => Right(invocation.positionalArguments[0]));
  });

  test(
      'have to return a Left with a stock error when stock ID is empty on update stock',
      () async {
    stock.id = '';
    final result = await updateStock(stock);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<StockError>());
    expect(
        result.fold((l) => l.message, (r) => null), 'Stock ID cannot be empty');
  });

  test('have to return a Right with a stock from repository on update stock',
      () async {
    final result = await updateStock(stock);

    expect(result, isA<Right>());
    expect(result.fold(id, id), isA<Stock>());
  });
}
