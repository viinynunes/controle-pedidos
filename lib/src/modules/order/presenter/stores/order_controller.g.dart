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

  late final _$sortByDateAtom =
      Atom(name: '_OrderControllerBase.sortByDate', context: context);

  @override
  bool get sortByDate {
    _$sortByDateAtom.reportRead();
    return super.sortByDate;
  }

  @override
  set sortByDate(bool value) {
    _$sortByDateAtom.reportWrite(value, super.sortByDate, () {
      super.sortByDate = value;
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

  late final _$dateRangeSelectedAtom =
      Atom(name: '_OrderControllerBase.dateRangeSelected', context: context);

  @override
  String get dateRangeSelected {
    _$dateRangeSelectedAtom.reportRead();
    return super.dateRangeSelected;
  }

  @override
  set dateRangeSelected(String value) {
    _$dateRangeSelectedAtom.reportWrite(value, super.dateRangeSelected, () {
      super.dateRangeSelected = value;
    });
  }

  late final _$initStateAsyncAction =
      AsyncAction('_OrderControllerBase.initState', context: context);

  @override
  Future initState(
      {required List<Product> productList, required List<Client> clientList}) {
    return _$initStateAsyncAction.run(() =>
        super.initState(productList: productList, clientList: clientList));
  }

  late final _$changeDateRangeSelectedAsyncAction = AsyncAction(
      '_OrderControllerBase.changeDateRangeSelected',
      context: context);

  @override
  Future changeDateRangeSelected(DateTime iniDate, DateTime endDate) {
    return _$changeDateRangeSelectedAsyncAction
        .run(() => super.changeDateRangeSelected(iniDate, endDate));
  }

  late final _$getOrderListBetweenDatesAsyncAction = AsyncAction(
      '_OrderControllerBase.getOrderListBetweenDates',
      context: context);

  @override
  Future getOrderListBetweenDates() {
    return _$getOrderListBetweenDatesAsyncAction
        .run(() => super.getOrderListBetweenDates());
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

  late final _$disableOrderAsyncAction =
      AsyncAction('_OrderControllerBase.disableOrder', context: context);

  @override
  Future disableOrder(o.Order order) {
    return _$disableOrderAsyncAction.run(() => super.disableOrder(order));
  }

  late final _$_OrderControllerBaseActionController =
      ActionController(name: '_OrderControllerBase', context: context);

  @override
  dynamic changeSortMethod() {
    final _$actionInfo = _$_OrderControllerBaseActionController.startAction(
        name: '_OrderControllerBase.changeSortMethod');
    try {
      return super.changeSortMethod();
    } finally {
      _$_OrderControllerBaseActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
searchText: ${searchText},
searching: ${searching},
loading: ${loading},
sortByDate: ${sortByDate},
error: ${error},
productList: ${productList},
clientList: ${clientList},
orderList: ${orderList},
filteredOrderList: ${filteredOrderList},
dateRangeSelected: ${dateRangeSelected}
    ''';
  }
}
