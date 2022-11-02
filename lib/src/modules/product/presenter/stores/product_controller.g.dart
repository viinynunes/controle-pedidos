// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductController on _ProductControllerBase, Store {
  late final _$searchTextAtom =
      Atom(name: '_ProductControllerBase.searchText', context: context);

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

  late final _$searchingAtom =
      Atom(name: '_ProductControllerBase.searching', context: context);

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

  late final _$loadingAtom =
      Atom(name: '_ProductControllerBase.loading', context: context);

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

  late final _$errorAtom =
      Atom(name: '_ProductControllerBase.error', context: context);

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

  late final _$productListAtom =
      Atom(name: '_ProductControllerBase.productList', context: context);

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

  late final _$filteredProductListAtom = Atom(
      name: '_ProductControllerBase.filteredProductList', context: context);

  @override
  ObservableList<Product> get filteredProductList {
    _$filteredProductListAtom.reportRead();
    return super.filteredProductList;
  }

  @override
  set filteredProductList(ObservableList<Product> value) {
    _$filteredProductListAtom.reportWrite(value, super.filteredProductList, () {
      super.filteredProductList = value;
    });
  }

  late final _$initStateAsyncAction =
      AsyncAction('_ProductControllerBase.initState', context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$getProductListAsyncAction =
      AsyncAction('_ProductControllerBase.getProductList', context: context);

  @override
  Future getProductList() {
    return _$getProductListAsyncAction.run(() => super.getProductList());
  }

  late final _$callProductRegistrationPageAsyncAction = AsyncAction(
      '_ProductControllerBase.callProductRegistrationPage',
      context: context);

  @override
  Future callProductRegistrationPage(
      {required BuildContext context,
      required IProductRegistrationPage registrationPage}) {
    return _$callProductRegistrationPageAsyncAction.run(() => super
        .callProductRegistrationPage(
            context: context, registrationPage: registrationPage));
  }

  late final _$_ProductControllerBaseActionController =
      ActionController(name: '_ProductControllerBase', context: context);

  @override
  dynamic filterProductListByText() {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.filterProductListByText');
    try {
      return super.filterProductListByText();
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
searching: ${searching},
loading: ${loading},
error: ${error},
productList: ${productList},
filteredProductList: ${filteredProductList}
    ''';
  }
}
