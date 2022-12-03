// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_stock_by_provider_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReportStockByProviderController
    on _ReportStockByProviderControllerBase, Store {
  late final _$dateRangeAtom = Atom(
      name: '_ReportStockByProviderControllerBase.dateRange', context: context);

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
      name: '_ReportStockByProviderControllerBase.loading', context: context);

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

  late final _$stockListAtom = Atom(
      name: '_ReportStockByProviderControllerBase.stockList', context: context);

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

  late final _$errorAtom = Atom(
      name: '_ReportStockByProviderControllerBase.error', context: context);

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

  late final _$providerListAtom = Atom(
      name: '_ReportStockByProviderControllerBase.providerList',
      context: context);

  @override
  Set<Provider> get providerList {
    _$providerListAtom.reportRead();
    return super.providerList;
  }

  @override
  set providerList(Set<Provider> value) {
    _$providerListAtom.reportWrite(value, super.providerList, () {
      super.providerList = value;
    });
  }

  late final _$providerModelListAtom = Atom(
      name: '_ReportStockByProviderControllerBase.providerModelList',
      context: context);

  @override
  List<ReportProviderModel> get providerModelList {
    _$providerModelListAtom.reportRead();
    return super.providerModelList;
  }

  @override
  set providerModelList(List<ReportProviderModel> value) {
    _$providerModelListAtom.reportWrite(value, super.providerModelList, () {
      super.providerModelList = value;
    });
  }

  late final _$selectedReportProviderModelAtom = Atom(
      name: '_ReportStockByProviderControllerBase.selectedReportProviderModel',
      context: context);

  @override
  ReportProviderModel? get selectedReportProviderModel {
    _$selectedReportProviderModelAtom.reportRead();
    return super.selectedReportProviderModel;
  }

  @override
  set selectedReportProviderModel(ReportProviderModel? value) {
    _$selectedReportProviderModelAtom
        .reportWrite(value, super.selectedReportProviderModel, () {
      super.selectedReportProviderModel = value;
    });
  }

  late final _$initStateAsyncAction = AsyncAction(
      '_ReportStockByProviderControllerBase.initState',
      context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$setDateRangeAsyncAction = AsyncAction(
      '_ReportStockByProviderControllerBase.setDateRange',
      context: context);

  @override
  Future setDateRange(DateTime iniDate, DateTime endDate) {
    return _$setDateRangeAsyncAction
        .run(() => super.setDateRange(iniDate, endDate));
  }

  late final _$resetDateRangeAsyncAction = AsyncAction(
      '_ReportStockByProviderControllerBase.resetDateRange',
      context: context);

  @override
  Future resetDateRange() {
    return _$resetDateRangeAsyncAction.run(() => super.resetDateRange());
  }

  late final _$getStockListBetweenDatesAsyncAction = AsyncAction(
      '_ReportStockByProviderControllerBase.getStockListBetweenDates',
      context: context);

  @override
  Future getStockListBetweenDates() {
    return _$getStockListBetweenDatesAsyncAction
        .run(() => super.getStockListBetweenDates());
  }

  late final _$_ReportStockByProviderControllerBaseActionController =
      ActionController(
          name: '_ReportStockByProviderControllerBase', context: context);

  @override
  dynamic _setDateRangeString() {
    final _$actionInfo =
        _$_ReportStockByProviderControllerBaseActionController.startAction(
            name: '_ReportStockByProviderControllerBase._setDateRangeString');
    try {
      return super._setDateRangeString();
    } finally {
      _$_ReportStockByProviderControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelectedProviderModel(ReportProviderModel provider) {
    final _$actionInfo =
        _$_ReportStockByProviderControllerBaseActionController.startAction(
            name:
                '_ReportStockByProviderControllerBase.setSelectedProviderModel');
    try {
      return super.setSelectedProviderModel(provider);
    } finally {
      _$_ReportStockByProviderControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dateRange: ${dateRange},
loading: ${loading},
stockList: ${stockList},
error: ${error},
providerList: ${providerList},
providerModelList: ${providerModelList},
selectedReportProviderModel: ${selectedReportProviderModel}
    ''';
  }
}
