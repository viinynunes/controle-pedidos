// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderController on _OrderControllerBase, Store {
  late final _$searchTextAtom =
      Atom(name: '_OrderControllerBase.searchText', context: context);

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
      Atom(name: '_OrderControllerBase.searching', context: context);

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
      Atom(name: '_OrderControllerBase.loading', context: context);

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

  late final _$selectedDateAtom =
      Atom(name: '_OrderControllerBase.selectedDate', context: context);

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_OrderControllerBase.error', context: context);

  @override
  Option<OrderError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<OrderError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$productListAtom =
      Atom(name: '_OrderControllerBase.productList', context: context);

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

  late final _$clientListAtom =
      Atom(name: '_OrderControllerBase.clientList', context: context);

  @override
  ObservableList<Client> get clientList {
    _$clientListAtom.reportRead();
    return super.clientList;
  }

  @override
  set clientList(ObservableList<Client> value) {
    _$clientListAtom.reportWrite(value, super.clientList, () {
      super.clientList = value;
    });
  }

  late final _$orderListAtom =
      Atom(name: '_OrderControllerBase.orderList', context: context);

  @override
  ObservableList<o.Order> get orderList {
    _$orderListAtom.reportRead();
    return super.orderList;
  }

  @override
  set orderList(ObservableList<o.Order> value) {
    _$orderListAtom.reportWrite(value, super.orderList, () {
      super.orderList = value;
    });
  }

  late final _$filteredOrderListAtom =
      Atom(name: '_OrderControllerBase.filteredOrderList', context: context);

  @override
  ObservableList<o.Order> get filteredOrderList {
    _$filteredOrderListAtom.reportRead();
    return super.filteredOrderList;
  }

  @override
  set filteredOrderList(ObservableList<o.Order> value) {
    _$filteredOrderListAtom.reportWrite(value, super.filteredOrderList, () {
      super.filteredOrderList = value;
    });
  }

  late final _$initStateAsyncAction =
      AsyncAction('_OrderControllerBase.initState', context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$getOrderListByDateAsyncAction =
      AsyncAction('_OrderControllerBase.getOrderListByDate', context: context);

  @override
  Future getOrderListByDate() {
    return _$getOrderListByDateAsyncAction
        .run(() => super.getOrderListByDate());
  }

  late final _$callOrderRegistrationPageAsyncAction = AsyncAction(
      '_OrderControllerBase.callOrderRegistrationPage',
      context: context);

  @override
  Future callOrderRegistrationPage(
      {required BuildContext context,
      required IOrderRegistrationPage registrationPage}) {
    return _$callOrderRegistrationPageAsyncAction.run(() => super
        .callOrderRegistrationPage(
            context: context, registrationPage: registrationPage));
  }

  late final _$getProductListByEnabledAsyncAction = AsyncAction(
      '_OrderControllerBase.getProductListByEnabled',
      context: context);

  @override
  Future getProductListByEnabled() {
    return _$getProductListByEnabledAsyncAction
        .run(() => super.getProductListByEnabled());
  }

  late final _$getClientListByEnabledAsyncAction = AsyncAction(
      '_OrderControllerBase.getClientListByEnabled',
      context: context);

  @override
  Future getClientListByEnabled() {
    return _$getClientListByEnabledAsyncAction
        .run(() => super.getClientListByEnabled());
  }

  late final _$_OrderControllerBaseActionController =
      ActionController(name: '_OrderControllerBase', context: context);

  @override
  dynamic filterOrderListByText() {
    final _$actionInfo = _$_OrderControllerBaseActionController.startAction(
        name: '_OrderControllerBase.filterOrderListByText');
    try {
      return super.filterOrderListByText();
    } finally {
      _$_OrderControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeSelectedDate(DateTime date) {
    final _$actionInfo = _$_OrderControllerBaseActionController.startAction(
        name: '_OrderControllerBase.changeSelectedDate');
    try {
      return super.changeSelectedDate(date);
    } finally {
      _$_OrderControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
searching: ${searching},
loading: ${loading},
selectedDate: ${selectedDate},
error: ${error},
productList: ${productList},
clientList: ${clientList},
orderList: ${orderList},
filteredOrderList: ${filteredOrderList}
    ''';
  }
}
