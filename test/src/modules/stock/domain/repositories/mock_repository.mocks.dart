// Mocks generated by Mockito 5.3.2 from annotations
// in controle_pedidos/test/src/modules/stock/domain/repositories/mock_repository.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:controle_pedidos/src/domain/entities/product.dart' as _i7;
import 'package:controle_pedidos/src/domain/entities/provider.dart' as _i8;
import 'package:controle_pedidos/src/domain/entities/stock.dart' as _i6;
import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart'
    as _i3;
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart'
    as _i5;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [INewStockRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockINewStockRepository extends _i1.Mock
    implements _i3.INewStockRepository {
  MockINewStockRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>> increaseTotalFromStock({
    required _i7.Product? product,
    required DateTime? date,
    required int? increaseQuantity,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #increaseTotalFromStock,
          [],
          {
            #product: product,
            #date: date,
            #increaseQuantity: increaseQuantity,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
            _FakeEither_0<_i5.StockError, _i6.Stock>(
          this,
          Invocation.method(
            #increaseTotalFromStock,
            [],
            {
              #product: product,
              #date: date,
              #increaseQuantity: increaseQuantity,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>> decreaseTotalFromStock({
    required _i7.Product? product,
    required DateTime? date,
    required int? decreaseQuantity,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #decreaseTotalFromStock,
          [],
          {
            #product: product,
            #date: date,
            #decreaseQuantity: decreaseQuantity,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
            _FakeEither_0<_i5.StockError, _i6.Stock>(
          this,
          Invocation.method(
            #decreaseTotalFromStock,
            [],
            {
              #product: product,
              #date: date,
              #decreaseQuantity: decreaseQuantity,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>> changeStockDate({
    required String? stockId,
    required DateTime? newDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #changeStockDate,
          [],
          {
            #stockId: stockId,
            #newDate: newDate,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
            _FakeEither_0<_i5.StockError, _i6.Stock>(
          this,
          Invocation.method(
            #changeStockDate,
            [],
            {
              #stockId: stockId,
              #newDate: newDate,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>
      duplicateStockWithoutProperties({
    required String? stockID,
    required _i8.Provider? newProvider,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #duplicateStockWithoutProperties,
              [],
              {
                #stockID: stockID,
                #newProvider: newProvider,
              },
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
                    _FakeEither_0<_i5.StockError, _i6.Stock>(
              this,
              Invocation.method(
                #duplicateStockWithoutProperties,
                [],
                {
                  #stockID: stockID,
                  #newProvider: newProvider,
                },
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>> moveStockWithProperties({
    required String? stockID,
    required _i8.Provider? newProvider,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #moveStockWithProperties,
          [],
          {
            #stockID: stockID,
            #newProvider: newProvider,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
            _FakeEither_0<_i5.StockError, _i6.Stock>(
          this,
          Invocation.method(
            #moveStockWithProperties,
            [],
            {
              #stockID: stockID,
              #newProvider: newProvider,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>
      increaseTotalOrderedFromStock({
    required String? stockID,
    required int? increaseQuantity,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #increaseTotalOrderedFromStock,
              [],
              {
                #stockID: stockID,
                #increaseQuantity: increaseQuantity,
              },
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
                    _FakeEither_0<_i5.StockError, _i6.Stock>(
              this,
              Invocation.method(
                #increaseTotalOrderedFromStock,
                [],
                {
                  #stockID: stockID,
                  #increaseQuantity: increaseQuantity,
                },
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>
      decreaseTotalOrderedFromStock({
    required String? stockID,
    required int? decreaseQuantity,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #decreaseTotalOrderedFromStock,
              [],
              {
                #stockID: stockID,
                #decreaseQuantity: decreaseQuantity,
              },
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
                    _FakeEither_0<_i5.StockError, _i6.Stock>(
              this,
              Invocation.method(
                #decreaseTotalOrderedFromStock,
                [],
                {
                  #stockID: stockID,
                  #decreaseQuantity: decreaseQuantity,
                },
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>> updateStock(
          _i6.Stock? stock) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateStock,
          [stock],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
            _FakeEither_0<_i5.StockError, _i6.Stock>(
          this,
          Invocation.method(
            #updateStock,
            [stock],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>> deleteStock(
          _i6.Stock? stock) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteStock,
          [stock],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>.value(
            _FakeEither_0<_i5.StockError, _i6.Stock>(
          this,
          Invocation.method(
            #deleteStock,
            [stock],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.StockError, _i6.Stock>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, Set<_i8.Provider>>>
      getProviderListByStockBetweenDates({
    required DateTime? iniDate,
    required DateTime? endDate,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #getProviderListByStockBetweenDates,
              [],
              {
                #iniDate: iniDate,
                #endDate: endDate,
              },
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.StockError, Set<_i8.Provider>>>.value(
                    _FakeEither_0<_i5.StockError, Set<_i8.Provider>>(
              this,
              Invocation.method(
                #getProviderListByStockBetweenDates,
                [],
                {
                  #iniDate: iniDate,
                  #endDate: endDate,
                },
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.StockError, Set<_i8.Provider>>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, List<_i6.Stock>>>
      getStockListByProviderBetweenDates({
    required _i8.Provider? provider,
    required DateTime? iniDate,
    required DateTime? endDate,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #getStockListByProviderBetweenDates,
              [],
              {
                #provider: provider,
                #iniDate: iniDate,
                #endDate: endDate,
              },
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.StockError, List<_i6.Stock>>>.value(
                    _FakeEither_0<_i5.StockError, List<_i6.Stock>>(
              this,
              Invocation.method(
                #getStockListByProviderBetweenDates,
                [],
                {
                  #provider: provider,
                  #iniDate: iniDate,
                  #endDate: endDate,
                },
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.StockError, List<_i6.Stock>>>);
  @override
  _i4.Future<_i2.Either<_i5.StockError, List<_i6.Stock>>>
      getStockListBetweenDates({
    required DateTime? iniDate,
    required DateTime? endDate,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #getStockListBetweenDates,
              [],
              {
                #iniDate: iniDate,
                #endDate: endDate,
              },
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.StockError, List<_i6.Stock>>>.value(
                    _FakeEither_0<_i5.StockError, List<_i6.Stock>>(
              this,
              Invocation.method(
                #getStockListBetweenDates,
                [],
                {
                  #iniDate: iniDate,
                  #endDate: endDate,
                },
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.StockError, List<_i6.Stock>>>);
}
