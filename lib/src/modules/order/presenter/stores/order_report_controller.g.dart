// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_report_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderReportController on _OrderReportControllerBase, Store {
  late final _$dateRangeAtom =
      Atom(name: '_OrderReportControllerBase.dateRange', context: context);

  @override
  String get dateRange {
    _$dateRangeAtom.reportRead();
    return super.dateRange;
  }

  @override
  set dateRange(String value) {
    _$dateRangeAtom.reportWrite(value, super.dateRange, () {
      super.dateRange = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_OrderReportControllerBase.loading', context: context);

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

  late final _$orderListAtom =
      Atom(name: '_OrderReportControllerBase.orderList', context: context);

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

  late final _$errorAtom =
      Atom(name: '_OrderReportControllerBase.error', context: context);

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

  late final _$initStateAsyncAction =
      AsyncAction('_OrderReportControllerBase.initState', context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$setDateRangeAsyncAction =
      AsyncAction('_OrderReportControllerBase.setDateRange', context: context);

  @override
  Future setDateRange(DateTime iniDate, DateTime endDate) {
    return _$setDateRangeAsyncAction
        .run(() => super.setDateRange(iniDate, endDate));
  }

  late final _$resetDateRangeAsyncAction = AsyncAction(
      '_OrderReportControllerBase.resetDateRange',
      context: context);

  @override
  Future resetDateRange() {
    return _$resetDateRangeAsyncAction.run(() => super.resetDateRange());
  }

  late final _$getOrderListByDateAsyncAction = AsyncAction(
      '_OrderReportControllerBase.getOrderListByDate',
      context: context);

  @override
  Future getOrderListByDate() {
    return _$getOrderListByDateAsyncAction
        .run(() => super.getOrderListByDate());
  }

  late final _$_OrderReportControllerBaseActionController =
      ActionController(name: '_OrderReportControllerBase', context: context);

  @override
  dynamic _setDateRangeString() {
    final _$actionInfo = _$_OrderReportControllerBaseActionController
        .startAction(name: '_OrderReportControllerBase._setDateRangeString');
    try {
      return super._setDateRangeString();
    } finally {
      _$_OrderReportControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dateRange: ${dateRange},
loading: ${loading},
orderList: ${orderList},
error: ${error}
    ''';
  }
}
