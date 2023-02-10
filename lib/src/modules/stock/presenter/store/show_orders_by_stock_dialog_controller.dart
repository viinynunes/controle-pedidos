import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/order.dart' as o;
import '../../errors/stock_error.dart';

part 'show_orders_by_stock_dialog_controller.g.dart';

class ShowOrdersByStockDialogController = _ShowOrdersByStockDialogControllerBase
    with _$ShowOrdersByStockDialogController;

abstract class _ShowOrdersByStockDialogControllerBase with Store {
  final IOrderUsecase orderUsecase;

  _ShowOrdersByStockDialogControllerBase(this.orderUsecase);

  @observable
  Stock? stock;
  @observable
  bool loading = false;
  @observable
  var orderListByStock = ObservableList<o.Order>.of([]);
  @observable
  DateTime iniDate = DateTime.now();
  @observable
  DateTime endDate = DateTime.now();
  @observable
  Option<StockError> error = none();

  @action
  initState(
      {required Stock stock,
      required DateTime iniDate,
      required DateTime endDate}) async {
    this.stock = stock;
    setIniDate(iniDate);
    setEndDate(endDate);

    await getOrderListByStock();
  }

  @action
  setIniDate(DateTime iniDate) {
    this.iniDate = iniDate;
  }

  @action
  setEndDate(DateTime endDate) {
    this.endDate = endDate;
  }

  @action
  resetIniDate(){
    iniDate = DateTime.now();
    getOrderListByStock();
  }

  @action
  resetEndDate(){
    endDate = DateTime.now();
    getOrderListByStock();
  }

  @action
  getOrderListByStock() async {
    loading = true;

    final result = await orderUsecase.getOrderListByEnabledAndProductAndDate(
        stock!.product, iniDate, endDate);

    result.fold((l) {
      error = optionOf(StockError(l.message));
    }, (r) => orderListByStock = ObservableList.of(r));

    loading = false;
  }
}
