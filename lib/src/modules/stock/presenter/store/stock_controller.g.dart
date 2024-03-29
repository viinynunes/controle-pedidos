// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StockController on _StockControllerBase, Store {
  late final _$selectedDateStringAtom =
      Atom(name: '_StockControllerBase.selectedDateString', context: context);

  @override
  String get selectedDateString {
    _$selectedDateStringAtom.reportRead();
    return super.selectedDateString;
  }

  @override
  set selectedDateString(String value) {
    _$selectedDateStringAtom.reportWrite(value, super.selectedDateString, () {
      super.selectedDateString = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_StockControllerBase.loading', context: context);

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

  late final _$providerListAtom =
      Atom(name: '_StockControllerBase.providerList', context: context);

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

  late final _$stockListAtom =
      Atom(name: '_StockControllerBase.stockList', context: context);

  @override
  ObservableList<Stock> get stockList {
    _$stockListAtom.reportRead();
    return super.stockList;
  }

  @override
  set stockList(ObservableList<Stock> value) {
    _$stockListAtom.reportWrite(value, super.stockList, () {
      super.stockList = value;
    });
  }

  late final _$selectedStockListAtom =
      Atom(name: '_StockControllerBase.selectedStockList', context: context);

  @override
  ObservableList<Stock> get selectedStockList {
    _$selectedStockListAtom.reportRead();
    return super.selectedStockList;
  }

  @override
  set selectedStockList(ObservableList<Stock> value) {
    _$selectedStockListAtom.reportWrite(value, super.selectedStockList, () {
      super.selectedStockList = value;
    });
  }

  late final _$selectedProviderAtom =
      Atom(name: '_StockControllerBase.selectedProvider', context: context);

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

  late final _$errorAtom =
      Atom(name: '_StockControllerBase.error', context: context);

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

  late final _$successAtom =
      Atom(name: '_StockControllerBase.success', context: context);

  @override
  Option<Stock> get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(Option<Stock> value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$initStateAsyncAction =
      AsyncAction('_StockControllerBase.initState', context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$getProductListAsyncAction =
      AsyncAction('_StockControllerBase.getProductList', context: context);

  @override
  Future getProductList() {
    return _$getProductListAsyncAction.run(() => super.getProductList());
  }

  late final _$getProviderListByStockBetweenDatesAsyncAction = AsyncAction(
      '_StockControllerBase.getProviderListByStockBetweenDates',
      context: context);

  @override
  Future getProviderListByStockBetweenDates() {
    return _$getProviderListByStockBetweenDatesAsyncAction
        .run(() => super.getProviderListByStockBetweenDates());
  }

  late final _$showEntitySelectionDialogAsyncAction = AsyncAction(
      '_StockControllerBase.showEntitySelectionDialog',
      context: context);

  @override
  Future showEntitySelectionDialog(BuildContext context) {
    return _$showEntitySelectionDialogAsyncAction
        .run(() => super.showEntitySelectionDialog(context));
  }

  late final _$getStockListByProviderBetweenDatesAsyncAction = AsyncAction(
      '_StockControllerBase.getStockListByProviderBetweenDates',
      context: context);

  @override
  Future getStockListByProviderBetweenDates() {
    return _$getStockListByProviderBetweenDatesAsyncAction
        .run(() => super.getStockListByProviderBetweenDates());
  }

  late final _$loadStockDefaultAsyncAction =
      AsyncAction('_StockControllerBase.loadStockDefault', context: context);

  @override
  Future loadStockDefault() {
    return _$loadStockDefaultAsyncAction.run(() => super.loadStockDefault());
  }

  late final _$createEmptyStockAsyncAction =
      AsyncAction('_StockControllerBase.createEmptyStock', context: context);

  @override
  Future createEmptyStock(Product product, bool reloadAfterCreate) {
    return _$createEmptyStockAsyncAction
        .run(() => super.createEmptyStock(product, reloadAfterCreate));
  }

  late final _$reloadProviderListAndStockListAsyncAction = AsyncAction(
      '_StockControllerBase.reloadProviderListAndStockList',
      context: context);

  @override
  Future reloadProviderListAndStockList(Provider provider) {
    return _$reloadProviderListAndStockListAsyncAction
        .run(() => super.reloadProviderListAndStockList(provider));
  }

  late final _$removeStockAsyncAction =
      AsyncAction('_StockControllerBase.removeStock', context: context);

  @override
  Future removeStock(Stock stock) {
    return _$removeStockAsyncAction.run(() => super.removeStock(stock));
  }

  late final _$_StockControllerBaseActionController =
      ActionController(name: '_StockControllerBase', context: context);

  @override
  dynamic setSelectedDateString() {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.setSelectedDateString');
    try {
      return super.setSelectedDateString();
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetDateToToday() {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.resetDateToToday');
    try {
      return super.resetDateToToday();
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelectedProvider(Provider provider) {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.setSelectedProvider');
    try {
      return super.setSelectedProvider(provider);
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getProviderDropdownItems(BuildContext context) {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.getProviderDropdownItems');
    try {
      return super.getProviderDropdownItems(context);
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addRemoveStockFromSelectedStockList(Stock stock) {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.addRemoveStockFromSelectedStockList');
    try {
      return super.addRemoveStockFromSelectedStockList(stock);
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic stockLeftSubmit(dynamic text) {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.stockLeftSubmit');
    try {
      return super.stockLeftSubmit(text);
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic reloadStockList() {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.reloadStockList');
    try {
      return super.reloadStockList();
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetStockLeft() {
    final _$actionInfo = _$_StockControllerBaseActionController.startAction(
        name: '_StockControllerBase.resetStockLeft');
    try {
      return super.resetStockLeft();
    } finally {
      _$_StockControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedDateString: ${selectedDateString},
loading: ${loading},
providerList: ${providerList},
stockList: ${stockList},
selectedStockList: ${selectedStockList},
selectedProvider: ${selectedProvider},
error: ${error},
success: ${success}
    ''';
  }
}
