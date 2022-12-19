import 'package:controle_pedidos/src/modules/stock/domain/usecases/i_stock_usecase.dart';
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
  final IStockUsecase usecase;

  _ReportStockByEstablishmentControllerBase(this.usecase);

  @observable
  String dateRange = '';
  @observable
  bool loading = false;
  @observable
  bool selecting = false;
  Set<Establishment> establishmentSet = {};
  Set<ReportEstablishmentModel> establishmentModelSet = {};
  Set<Provider> providerSet = {};
  List<ReportProviderModel> providerList = [];
  @observable
  List<ReportEstablishmentModel> establishmentList = ObservableList.of([]);
  @observable
  Option<StockError> error = none();

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
  getStockListBetweenDates() async {
    loading = true;

    final result = await usecase.getStockListBetweenDates(
        iniDate: iniDate, endDate: endDate);

    result.fold((l) => error = optionOf(l), (stockList) {

      for (var s in stockList) {
        providerSet.add(s.product.provider);
      }

      for (var p in providerSet) {
        providerList.add(ReportProviderModel(
            providerId: p.id,
            providerName: p.name,
            providerLocation: p.location,
            providerEstablishment: p.establishment,
            stockList: stockList
                .where((element) => element.product.provider.id == p.id)
                .toList(),
            merge: false));
      }
    });

    loading = false;
  }
}
