import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/change_stock_provider_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../domain/entities/product_mock.dart';
import '../../../../domain/entities/provider_mock.dart';
import '../../../../domain/entities/stock_mock.dart';
import '../repositories/mock_repository.mocks.dart';

main() {
  final repository = MockINewStockRepository();
  final usecase = ChangeStockProviderUsecaseImpl(repository);

  late ProviderModel provider;

  setUp(() {
    provider = ProviderMock.getOneProvider();

    when(repository.moveStockWithProperties(
            stockID: anyNamed('stockID'), newProvider: provider))
        .thenAnswer((_) async => Right(StockMock.getOneStock(
            product: ProductMock.getOneProduct(provider: provider))));

    when(repository.duplicateStockWithoutProperties(
        stockID: anyNamed('stockID'), newProvider: provider))
        .thenAnswer((_) async => Right(StockMock.getOneStock(
        product: ProductMock.getOneProduct(provider: provider))));
  });

  group('Tests to move stock with properties on usecase', (){
    test(
        'have to return a Left with a Stock Error when Stock ID is empty on change stock provider usecase',
            () async {
          final result = await usecase.moveStockWithProperties(stockID: '', newProvider: provider);

          expect(result, isA<Left>());
          expect(result.fold(id, id), isA<StockError>());
        });

    test(
        'have to return a Left with a Stock Error when new Provider ID is empty on change stock provider usecase',
            () async {
          provider.id = '';

          final result = await usecase.moveStockWithProperties(stockID: 'AAAA', newProvider: provider);

          expect(result, isA<Left>());
          expect(result.fold(id, id), isA<StockError>());
        });

    test(
        'have to return a Right from repository on change stock provider usecase',
            () async {
          final result = await usecase.moveStockWithProperties(stockID: 'AAAA', newProvider: provider);

          expect(result, isA<Right>());
          expect(result.fold(id, id), isA<Stock>());
        });
  });


  group('Tests to duplicate stock without properties on usecase', (){
    test(
        'have to return a Left with a Stock Error when Stock ID is empty on change stock provider usecase',
            () async {
          final result = await usecase.duplicateStockWithoutProperties(stockID: '', newProvider: provider);

          expect(result, isA<Left>());
          expect(result.fold(id, id), isA<StockError>());
        });

    test(
        'have to return a Left with a Stock Error when new Provider ID is empty on change stock provider usecase',
            () async {
          provider.id = '';

          final result = await usecase.duplicateStockWithoutProperties(stockID: 'AAAA', newProvider: provider);

          expect(result, isA<Left>());
          expect(result.fold(id, id), isA<StockError>());
        });

    test(
        'have to return a Right from repository on change stock provider usecase',
            () async {
          final result = await usecase.duplicateStockWithoutProperties(stockID: 'AAAA', newProvider: provider);

          expect(result, isA<Right>());
          expect(result.fold(id, id), isA<Stock>());
        });
  });


}
