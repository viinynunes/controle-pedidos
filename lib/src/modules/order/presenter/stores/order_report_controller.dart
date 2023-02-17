import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/admob/services/ad_service.dart';
import '../../../../domain/entities/order.dart' as o;
import '../../errors/order_info_exception.dart';
import '../../services/i_order_service.dart';

part 'order_report_controller.g.dart';

class OrderReportController = _OrderReportControllerBase
    with _$OrderReportController;

abstract class _OrderReportControllerBase with Store {
  final IOrderUsecase orderUsecase;
  final IOrderService orderService;
  final AdService adService;

  _OrderReportControllerBase(
      this.orderUsecase, this.orderService, this.adService);

  @observable
  String dateRange = '';
  @observable
  bool loading = false;
  @observable
  var orderList = ObservableList<o.Order>.of([]);
  @observable
  Option<OrderInfoException> error = none();

  List<o.Order> mergedOrderList = [];
  late DateTime iniDate, endDate;

  final dateFormat = DateFormat('dd-MM-yyyy');

  @action
  initState() async {
    resetDateRange();

    await getOrderListByDate();
  }

  @action
  setDateRange(DateTime iniDate, DateTime endDate) async {
    this.iniDate = iniDate;
    this.endDate = endDate;

    _setDateRangeString();
    await getOrderListByDate();
  }

  @action
  resetDateRange() async {
    iniDate = DateTime.now();
    endDate = DateTime.now();

    _setDateRangeString();

    await getOrderListByDate();
  }

  @action
  _setDateRangeString() {
    dateRange = '${dateFormat.format(iniDate)} | ${dateFormat.format(endDate)}';
  }

  @action
  getOrderListByDate() async {
    loading = true;

    final result =
        await orderUsecase.getOrderListByEnabledBetweenDates(iniDate, endDate);

    result.fold((l) => error = optionOf(l), (r) {
      orderService.sortOrderListByClientName(r);
      orderList = ObservableList.of(r);
    });

    loading = false;
  }

  mergeOrderList() async {
    loading = true;
    List<o.Order> backup = [];

    backup = orderList.toList();

    final result = orderService.mergeOrderListByClient(backup);

    result.fold((l) => error = optionOf(l), (r) => mergedOrderList = r);

    await getOrderListByDate();

    loading = false;
  }

  bool showAds() {
    return adService.loadAd();
  }
}
