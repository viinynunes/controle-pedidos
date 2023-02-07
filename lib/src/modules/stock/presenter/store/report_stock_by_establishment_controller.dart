import 'package:controle_pedidos/src/modules/stock/domain/usecases/get_stock_lists_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/services/i_stock_service.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/establishment.dart';
import '../../../../domain/entities/provider.dart';
import '../../../../domain/models/report_establishment_model.dart';
import '../../../../domain/models/report_provider_model.dart';
import '../../errors/stock_error.dart';

part 'report_stock_by_establishment_controller.g.dart';

class ReportStockByEstablishmentController = _ReportStockByEstablishmentControllerBase
    with _$ReportStockByEstablishmentController;

abstract class _ReportStockByEstablishmentControllerBase with Store {
  final GetStockListsUsecase usecase;
  final IStockService service;

  _ReportStockByEstablishmentControllerBase(this.usecase, this.service);

  @observable
  String dateRange = '';
  @observable
  bool loading = false;
  @observable
  bool selecting = false;
  Set<Establishment> establishmentSet = {};
  @observable
  List<ReportEstablishmentModel> establishmentList = ObservableList.of([]);
  Set<Provider> providerSet = {};
  @observable
  List<ReportProviderModel> providerList = [];
  @observable
  Option<StockError> error = none();

  late DateTime iniDate, endDate;
  final dateFormat = DateFormat('dd-MM-yyyy');

  @action
  initState() async {
    await setDateRange();
  }

  @action
  setDateRange({DateTime? iniDate, DateTime? endDate}) async {
    this.iniDate = iniDate ?? DateTime.now();
    this.endDate = endDate ?? DateTime.now();

    _setDateRangeString();
    await getStockListBetweenDates();
  }

  @action
  _setDateRangeString() {
    dateRange = '${dateFormat.format(iniDate)} | ${dateFormat.format(endDate)}';
  }

  @action
  getStockListBetweenDates() async {
    loading = true;

    providerList.clear();
    establishmentList.clear();
    establishmentSet.clear();
    providerSet.clear();

    final result = await usecase.getStockListBetweenDates(
        iniDate: iniDate, endDate: endDate);

    result.fold((l) => error = optionOf(l), (stockList) {
      service.sortStockListByProviderAndProductName(stockList);
      for (var s in stockList) {
        providerSet.add(s.product.provider);
      }

      for (var p in providerSet) {
        providerList.add(ReportProviderModel(
            provider: p,
            stockList: stockList
                .where((element) => element.product.provider.id == p.id)
                .toList(),
            merge: false));
      }

      for (var p in providerList) {
        establishmentSet.add(p.provider.establishment);
      }

      for (var e in establishmentSet) {
        establishmentList.add(ReportEstablishmentModel(
            establishment: e,
            selected: false,
            providerList: providerList
                .where((element) => element.provider.establishment.id == e.id)
                .toList()));
      }
    });

    loading = false;
  }
}
