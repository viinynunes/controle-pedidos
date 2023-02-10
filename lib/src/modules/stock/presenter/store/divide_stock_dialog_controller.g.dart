// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divide_stock_dialog_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DivideStockDialogController on _DivideStockDialogControllerBase, Store {
  late final _$stockAtom =
      Atom(name: '_DivideStockDialogControllerBase.stock', context: context);

  @override
  Stock? get stock {
    _$stockAtom.reportRead();
    return super.stock;
  }

  @override
  set stock(Stock? value) {
    _$stockAtom.reportWrite(value, super.stock, () {
      super.stock = value;
    });
  }

  late final _$selectedProviderAtom = Atom(
      name: '_DivideStockDialogControllerBase.selectedProvider',
      context: context);

  @override
  Provider? get selectedProvider {
    _$selectedProviderAtom.reportRead();
    return super.selectedProvider;
  }

  @override
  set selectedProvider(Provider? value) {
    _$selectedProviderAtom.reportWrite(value, super.selectedProvider, () {
      super.selectedProvider = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_DivideStockDialogControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$providerListAtom = Atom(
      name: '_DivideStockDialogControllerBase.providerList', context: context);

  @override
  ObservableList<Provider> get providerList {
    _$providerListAtom.reportRead();
    return super.providerList;
  }

  @override
  set providerList(ObservableList<Provider> value) {
    _$providerListAtom.reportWrite(value, super.providerList, () {
      super.providerList = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_DivideStockDialogControllerBase.error', context: context);

  @override
  Option<StockError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<StockError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$initStateAsyncAction = AsyncAction(
      '_DivideStockDialogControllerBase.initState',
      context: context);

  @override
  Future initState(Stock stock) {
    return _$initStateAsyncAction.run(() => super.initState(stock));
  }

  late final _$getProviderListByEnabledAsyncAction = AsyncAction(
      '_DivideStockDialogControllerBase.getProviderListByEnabled',
      context: context);

  @override
  Future getProviderListByEnabled() {
    return _$getProviderListByEnabledAsyncAction
        .run(() => super.getProviderListByEnabled());
  }

  late final _$moveStockWithPropertiesAsyncAction = AsyncAction(
      '_DivideStockDialogControllerBase.moveStockWithProperties',
      context: context);

  @override
  Future moveStockWithProperties(
      {required String stockID, required Provider newProvider}) {
    return _$moveStockWithPropertiesAsyncAction.run(() => super
        .moveStockWithProperties(stockID: stockID, newProvider: newProvider));
  }

  late final _$duplicateStockWithoutPropertiesAsyncAction = AsyncAction(
      '_DivideStockDialogControllerBase.duplicateStockWithoutProperties',
      context: context);

  @override
  Future duplicateStockWithoutProperties(
      {required String stockID, required Provider newProvider}) {
    return _$duplicateStockWithoutPropertiesAsyncAction.run(() => super
        .duplicateStockWithoutProperties(
            stockID: stockID, newProvider: newProvider));
  }

  late final _$_DivideStockDialogControllerBaseActionController =
      ActionController(
          name: '_DivideStockDialogControllerBase', context: context);

  @override
  dynamic setSelectedProvider(Provider provider) {
    final _$actionInfo =
        _$_DivideStockDialogControllerBaseActionController.startAction(
            name: '_DivideStockDialogControllerBase.setSelectedProvider');
    try {
      return super.setSelectedProvider(provider);
    } finally {
      _$_DivideStockDialogControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
stock: ${stock},
selectedProvider: ${selectedProvider},
loading: ${loading},
providerList: ${providerList},
error: ${error}
    ''';
  }
}
