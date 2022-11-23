// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stock_default_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductStockDefaultController
    on _ProductStockDefaultControllerBase, Store {
  late final _$loadingAtom = Atom(
      name: '_ProductStockDefaultControllerBase.loading', context: context);

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

  late final _$searchingAtom = Atom(
      name: '_ProductStockDefaultControllerBase.searching', context: context);

  @override
  bool get searching {
    _$searchingAtom.reportRead();
    return super.searching;
  }

  @override
  set searching(bool value) {
    _$searchingAtom.reportWrite(value, super.searching, () {
      super.searching = value;
    });
  }

  late final _$searchTextAtom = Atom(
      name: '_ProductStockDefaultControllerBase.searchText', context: context);

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  late final _$productListAtom = Atom(
      name: '_ProductStockDefaultControllerBase.productList', context: context);

  @override
  ObservableList<Product> get productList {
    _$productListAtom.reportRead();
    return super.productList;
  }

  @override
  set productList(ObservableList<Product> value) {
    _$productListAtom.reportWrite(value, super.productList, () {
      super.productList = value;
    });
  }

  late final _$productFilteredListAtom = Atom(
      name: '_ProductStockDefaultControllerBase.productFilteredList',
      context: context);

  @override
  ObservableList<Product> get productFilteredList {
    _$productFilteredListAtom.reportRead();
    return super.productFilteredList;
  }

  @override
  set productFilteredList(ObservableList<Product> value) {
    _$productFilteredListAtom.reportWrite(value, super.productFilteredList, () {
      super.productFilteredList = value;
    });
  }

  late final _$providerListAtom = Atom(
      name: '_ProductStockDefaultControllerBase.providerList',
      context: context);

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
      Atom(name: '_ProductStockDefaultControllerBase.error', context: context);

  @override
  Option<ProductError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<ProductError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$selectedProviderAtom = Atom(
      name: '_ProductStockDefaultControllerBase.selectedProvider',
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

  late final _$initStateAsyncAction = AsyncAction(
      '_ProductStockDefaultControllerBase.initState',
      context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$getProviderListAsyncAction = AsyncAction(
      '_ProductStockDefaultControllerBase.getProviderList',
      context: context);

  @override
  Future getProviderList() {
    return _$getProviderListAsyncAction.run(() => super.getProviderList());
  }

  late final _$getProductListByProviderAsyncAction = AsyncAction(
      '_ProductStockDefaultControllerBase.getProductListByProvider',
      context: context);

  @override
  Future getProductListByProvider() {
    return _$getProductListByProviderAsyncAction
        .run(() => super.getProductListByProvider());
  }

  late final _$updateProductAsyncAction = AsyncAction(
      '_ProductStockDefaultControllerBase.updateProduct',
      context: context);

  @override
  Future updateProduct(Product product) {
    return _$updateProductAsyncAction.run(() => super.updateProduct(product));
  }

  late final _$_ProductStockDefaultControllerBaseActionController =
      ActionController(
          name: '_ProductStockDefaultControllerBase', context: context);

  @override
  dynamic setSelectedProvider(Provider provider) {
    final _$actionInfo =
        _$_ProductStockDefaultControllerBaseActionController.startAction(
            name: '_ProductStockDefaultControllerBase.setSelectedProvider');
    try {
      return super.setSelectedProvider(provider);
    } finally {
      _$_ProductStockDefaultControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic toggleCheckbox(Product product) {
    final _$actionInfo = _$_ProductStockDefaultControllerBaseActionController
        .startAction(name: '_ProductStockDefaultControllerBase.toggleCheckbox');
    try {
      return super.toggleCheckbox(product);
    } finally {
      _$_ProductStockDefaultControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic reloadProductList() {
    final _$actionInfo =
        _$_ProductStockDefaultControllerBaseActionController.startAction(
            name: '_ProductStockDefaultControllerBase.reloadProductList');
    try {
      return super.reloadProductList();
    } finally {
      _$_ProductStockDefaultControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
searching: ${searching},
searchText: ${searchText},
productList: ${productList},
productFilteredList: ${productFilteredList},
providerList: ${providerList},
error: ${error},
selectedProvider: ${selectedProvider}
    ''';
  }
}
