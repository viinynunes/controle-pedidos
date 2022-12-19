import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/models/report_establishment_model.dart';

part 'report_stock_by_establishment_controller.g.dart';

class ReportStockByEstablishmentController = _ReportStockByEstablishmentControllerBase
    with _$ReportStockByEstablishmentController;

abstract class _ReportStockByEstablishmentControllerBase with Store {
  @observable
  String dateRange = '';
  @observable
  bool loading = false;
  @observable
  bool selecting = false;
  @observable
  List<ReportEstablishmentModel> establishmentList = ObservableList.of([]);

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
    //await getStockListBetweenDates();
  }

  @action
  resetDateRange() async {
    iniDate = DateTime.now();
    endDate = DateTime.now();

    _setDateRangeString();
    //await getStockListBetweenDates();
  }

  @action
  _setDateRangeString() {
    dateRange = '${dateFormat.format(iniDate)} | ${dateFormat.format(endDate)}';
  }
}
