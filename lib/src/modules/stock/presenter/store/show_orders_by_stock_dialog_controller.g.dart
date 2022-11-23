// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_orders_by_stock_dialog_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ShowOrdersByStockDialogController
    on _ShowOrdersByStockDialogControllerBase, Store {
  late final _$stockAtom = Atom(
      name: '_ShowOrdersByStockDialogControllerBase.stock', context: context);

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

  late final _$loadingAtom = Atom(
      name: '_ShowOrdersByStockDialogControllerBase.loading', context: context);

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

  late final _$orderListByStockAtom = Atom(
      name: '_ShowOrdersByStockDialogControllerBase.orderListByStock',
      context: context);

  @override
  ObservableList<Order> get orderListByStock {
    _$orderListByStockAtom.reportRead();
    return super.orderListByStock;
  }

  @override
  set orderListByStock(ObservableList<Order> value) {
    _$orderListByStockAtom.reportWrite(value, super.orderListByStock, () {
      super.orderListByStock = value;
    });
  }

  late final _$iniDateAtom = Atom(
      name: '_ShowOrdersByStockDialogControllerBase.iniDate', context: context);

  @override
  DateTime get iniDate {
    _$iniDateAtom.reportRead();
    return super.iniDate;
  }

  @override
  set iniDate(DateTime value) {
    _$iniDateAtom.reportWrite(value, super.iniDate, () {
      super.iniDate = value;
    });
  }

  late final _$endDateAtom = Atom(
      name: '_ShowOrdersByStockDialogControllerBase.endDate', context: context);

  @override
  DateTime get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(DateTime value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  late final _$initStateAsyncAction = AsyncAction(
      '_ShowOrdersByStockDialogControllerBase.initState',
      context: context);

  @override
  Future initState(
      {required Stock stock,
      required DateTime iniDate,
      required DateTime endDate}) {
    return _$initStateAsyncAction.run(() =>
        super.initState(stock: stock, iniDate: iniDate, endDate: endDate));
  }

  late final _$getOrderListByStockAsyncAction = AsyncAction(
      '_ShowOrdersByStockDialogControllerBase.getOrderListByStock',
      context: context);

  @override
  Future getOrderListByStock() {
    return _$getOrderListByStockAsyncAction
        .run(() => super.getOrderListByStock());
  }

  late final _$_ShowOrdersByStockDialogControllerBaseActionController =
      ActionController(
          name: '_ShowOrdersByStockDialogControllerBase', context: context);

  @override
  dynamic setIniDate(DateTime iniDate) {
    final _$actionInfo =
        _$_ShowOrdersByStockDialogControllerBaseActionController.startAction(
            name: '_ShowOrdersByStockDialogControllerBase.setIniDate');
    try {
      return super.setIniDate(iniDate);
    } finally {
      _$_ShowOrdersByStockDialogControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEndDate(DateTime endDate) {
    final _$actionInfo =
        _$_ShowOrdersByStockDialogControllerBaseActionController.startAction(
            name: '_ShowOrdersByStockDialogControllerBase.setEndDate');
    try {
      return super.setEndDate(endDate);
    } finally {
      _$_ShowOrdersByStockDialogControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetIniDate() {
    final _$actionInfo =
        _$_ShowOrdersByStockDialogControllerBaseActionController.startAction(
            name: '_ShowOrdersByStockDialogControllerBase.resetIniDate');
    try {
      return super.resetIniDate();
    } finally {
      _$_ShowOrdersByStockDialogControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetEndDate() {
    final _$actionInfo =
        _$_ShowOrdersByStockDialogControllerBaseActionController.startAction(
            name: '_ShowOrdersByStockDialogControllerBase.resetEndDate');
    try {
      return super.resetEndDate();
    } finally {
      _$_ShowOrdersByStockDialogControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
stock: ${stock},
loading: ${loading},
orderListByStock: ${orderListByStock},
iniDate: ${iniDate},
endDate: ${endDate}
    ''';
  }
}
