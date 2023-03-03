// Mocks generated by Mockito 5.3.2 from annotations
// in controle_pedidos/test/src/modules/stock/external/mocks/mock_datasource.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:controle_pedidos/src/domain/models/product_model.dart' as _i5;
import 'package:controle_pedidos/src/domain/models/provider_model.dart' as _i6;
import 'package:controle_pedidos/src/domain/models/stock_model.dart' as _i2;
import 'package:controle_pedidos/src/modules/stock/infra/datasources/i_new_stock_datasource.dart'
    as _i3;
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

class _FakeStockModel_0 extends _i1.SmartFake implements _i2.StockModel {
  _FakeStockModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [INewStockDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockINewStockDatasource extends _i1.Mock
    implements _i3.INewStockDatasource {
  MockINewStockDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.StockModel> createStock({
    required _i2.StockModel? stock,
    String? stockID = r'',
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createStock,
          [],
          {
            #stock: stock,
            #stockID: stockID,
          },
        ),
        returnValue: _i4.Future<_i2.StockModel>.value(_FakeStockModel_0(
          this,
          Invocation.method(
            #createStock,
            [],
            {
              #stock: stock,
              #stockID: stockID,
            },
          ),
        )),
      ) as _i4.Future<_i2.StockModel>);
  @override
  _i4.Future<_i2.StockModel> updateStock({required _i2.StockModel? stock}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateStock,
          [],
          {#stock: stock},
        ),
        returnValue: _i4.Future<_i2.StockModel>.value(_FakeStockModel_0(
          this,
          Invocation.method(
            #updateStock,
            [],
            {#stock: stock},
          ),
        )),
      ) as _i4.Future<_i2.StockModel>);
  @override
  _i4.Future<void> updateStockFromProduct(
          {required _i5.ProductModel? product}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateStockFromProduct,
          [],
          {#product: product},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<_i2.StockModel> deleteStock({required _i2.StockModel? stock}) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteStock,
          [],
          {#stock: stock},
        ),
        returnValue: _i4.Future<_i2.StockModel>.value(_FakeStockModel_0(
          this,
          Invocation.method(
            #deleteStock,
            [],
            {#stock: stock},
          ),
        )),
      ) as _i4.Future<_i2.StockModel>);
  @override
  _i4.Future<_i2.StockModel?> getStockByCode({required String? code}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getStockByCode,
          [],
          {#code: code},
        ),
        returnValue: _i4.Future<_i2.StockModel?>.value(),
      ) as _i4.Future<_i2.StockModel?>);
  @override
  _i4.Future<_i2.StockModel> getStockById({required String? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getStockById,
          [],
          {#id: id},
        ),
        returnValue: _i4.Future<_i2.StockModel>.value(_FakeStockModel_0(
          this,
          Invocation.method(
            #getStockById,
            [],
            {#id: id},
          ),
        )),
      ) as _i4.Future<_i2.StockModel>);
  @override
  _i4.Future<Set<_i6.ProviderModel>> getProviderListByStockBetweenDates({
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
            _i4.Future<Set<_i6.ProviderModel>>.value(<_i6.ProviderModel>{}),
      ) as _i4.Future<Set<_i6.ProviderModel>>);
  @override
  _i4.Future<List<_i2.StockModel>> getStockListByProviderBetweenDates({
    required _i6.ProviderModel? provider,
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
        returnValue: _i4.Future<List<_i2.StockModel>>.value(<_i2.StockModel>[]),
      ) as _i4.Future<List<_i2.StockModel>>);
  @override
  _i4.Future<List<_i2.StockModel>> getStockListBetweenDates({
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
        returnValue: _i4.Future<List<_i2.StockModel>>.value(<_i2.StockModel>[]),
      ) as _i4.Future<List<_i2.StockModel>>);
}
