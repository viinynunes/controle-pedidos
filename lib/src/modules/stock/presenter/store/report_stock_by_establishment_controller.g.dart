// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_stock_by_establishment_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReportStockByEstablishmentController
    on _ReportStockByEstablishmentControllerBase, Store {
  late final _$dateRangeAtom = Atom(
      name: '_ReportStockByEstablishmentControllerBase.dateRange',
      context: context);

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

  late final _$loadingAtom = Atom(
      name: '_ReportStockByEstablishmentControllerBase.loading',
      context: context);

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

  late final _$selectingAtom = Atom(
      name: '_ReportStockByEstablishmentControllerBase.selecting',
      context: context);

  @override
  bool get selecting {
    _$selectingAtom.reportRead();
    return super.selecting;
  }

  @override
  set selecting(bool value) {
    _$selectingAtom.reportWrite(value, super.selecting, () {
      super.selecting = value;
    });
  }

  late final _$establishmentListAtom = Atom(
      name: '_ReportStockByEstablishmentControllerBase.establishmentList',
      context: context);

  @override
  List<ReportEstablishmentModel> get establishmentList {
    _$establishmentListAtom.reportRead();
    return super.establishmentList;
  }

  @override
  set establishmentList(List<ReportEstablishmentModel> value) {
    _$establishmentListAtom.reportWrite(value, super.establishmentList, () {
      super.establishmentList = value;
    });
  }

  late final _$initStateAsyncAction = AsyncAction(
      '_ReportStockByEstablishmentControllerBase.initState',
      context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$setDateRangeAsyncAction = AsyncAction(
      '_ReportStockByEstablishmentControllerBase.setDateRange',
      context: context);

  @override
  Future setDateRange(DateTime iniDate, DateTime endDate) {
    return _$setDateRangeAsyncAction
        .run(() => super.setDateRange(iniDate, endDate));
  }

  late final _$resetDateRangeAsyncAction = AsyncAction(
      '_ReportStockByEstablishmentControllerBase.resetDateRange',
      context: context);

  @override
  Future resetDateRange() {
    return _$resetDateRangeAsyncAction.run(() => super.resetDateRange());
  }

  late final _$_ReportStockByEstablishmentControllerBaseActionController =
      ActionController(
          name: '_ReportStockByEstablishmentControllerBase', context: context);

  @override
  dynamic _setDateRangeString() {
    final _$actionInfo =
        _$_ReportStockByEstablishmentControllerBaseActionController.startAction(
            name:
                '_ReportStockByEstablishmentControllerBase._setDateRangeString');
    try {
      return super._setDateRangeString();
    } finally {
      _$_ReportStockByEstablishmentControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dateRange: ${dateRange},
loading: ${loading},
selecting: ${selecting},
establishmentList: ${establishmentList}
    ''';
  }
}
