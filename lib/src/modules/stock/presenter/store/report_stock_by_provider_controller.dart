import 'package:controle_pedidos/src/modules/stock/domain/usecases/i_stock_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/services/i_stock_service.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';
import '../model/report_provider_model.dart';

part 'report_stock_by_provider_controller.g.dart';

class ReportStockByProviderController = _ReportStockByProviderControllerBase
    with _$ReportStockByProviderController;

abstract class _ReportStockByProviderControllerBase with Store {
  final IStockUsecase stockUsecase;
  final IStockService stockService;

  _ReportStockByProviderControllerBase(this.stockUsecase, this.stockService);

  @observable
  String dateRange = '';
  @observable
  bool loading = false;
  @observable
  var stockList = ObservableList<Stock>.of([]);
  @observable
  Option<StockError> error = none();

  @observable
  Set<Provider> providerList = {};
  @observable
  List<ReportProviderModel> providerModelList = ObservableList.of([]);
  @observable
  List<ReportProviderModel> selectedProviderModelList = ObservableList.of([]);
  @observable
  ReportProviderModel? selectedReportProviderModel;
  late DateTime iniDate, endDate;
  final dateFormat = DateFormat('dd-MM-yyyy');

  @action
  initState() async {
    await resetDateRange();
  }

  @action
  setDateRange(DateTime iniDate, DateTime endDate) async {
    this.iniDate = iniDate;
    this.endDate = endDate;

    _setDateRangeString();
    await getStockListBetweenDates();
  }

  @action
  resetDateRange() async {
    iniDate = DateTime.now();
    endDate = DateTime.now();

    _setDateRangeString();
    await getStockListBetweenDates();
  }

  @action
  _setDateRangeString() {
    dateRange = '${dateFormat.format(iniDate)} | ${dateFormat.format(endDate)}';
  }

  @action
  List<ReportProviderModel> getProviderListToShare() {
    if (selectedProviderModelList.isEmpty) {
      for (var p in providerList) {
        selectedProviderModelList.add(
          ReportProviderModel(
              providerId: p.id,
              providerName: p.name,
              providerLocation: p.location,
              stockList: stockList
                  .where((element) => element.product.providerId == p.id)
                  .toList(),
              merge: false),
        );
      }
    }

    return selectedProviderModelList;
  }

  @action
  getStockListBetweenDates() async {
    loading = true;

    stockList.clear();
    providerList.clear();
    providerModelList.clear();
    selectedProviderModelList.clear();

    final result = await stockUsecase.getStockListBetweenDates(
        iniDate: iniDate, endDate: endDate);

    result.fold((l) => error = optionOf(l), (r) {
      stockService.sortStockListByProviderAndProductName(r);
      stockList = ObservableList.of(r);
      for (var s in r) {
        providerList.add(s.product.provider!);
      }
      for (var p in providerList) {
        providerModelList.add(ReportProviderModel(
            providerId: p.id,
            providerName: p.name,
            providerLocation: p.location,
            stockList: stockList
                .where((element) => element.product.providerId == p.id)
                .toList(),
            merge: false));
      }
    });

    loading = false;
  }

  @action
  addSelectedReportProviderModel(ReportProviderModel provider) {
    selectedProviderModelList.add(provider);
  }

  @action
  removeReportProviderModel(ReportProviderModel provider) {
    selectedProviderModelList.remove(provider);
    provider.merge = false;
  }

  @action
  toggleMerge(ReportProviderModel provider) {
    provider.merge = !provider.merge;
  }
}
