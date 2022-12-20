import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/order/presenter/pages/i_order_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/order.dart' as o;
import '../../errors/order_error.dart';
import '../../services/i_order_service.dart';

part 'order_controller.g.dart';

class OrderController = _OrderControllerBase with _$OrderController;

abstract class _OrderControllerBase with Store {
  final IOrderService orderService;
  final IOrderUsecase orderUsecase;

  _OrderControllerBase(this.orderUsecase, this.orderService);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  bool sortByDate = true;
  @observable
  Option<OrderError> error = none();
  @observable
  var productList = ObservableList<Product>.of([]);
  @observable
  var clientList = ObservableList<Client>.of([]);
  @observable
  var orderList = ObservableList<o.Order>.of([]);
  @observable
  var filteredOrderList = ObservableList<o.Order>.of([]);
  @observable
  String dateRangeSelected = '';

  late DateTime iniDate;
  late DateTime endDate;

  final dateFormat = DateFormat('dd-MM-yyyy');
  final searchFocus = FocusNode();

  @action
  initState(
      {required List<Product> productList,
      required List<Client> clientList}) async {
    resetDateRange();

    this.productList = ObservableList.of(productList);
    this.clientList = ObservableList.of(clientList);
  }

  @action
  changeDateRangeSelected(DateTime iniDate, DateTime endDate) async {
    this.iniDate = iniDate;
    this.endDate = endDate;

    _setDateRangeString();

    await getOrderListBetweenDates();
  }

  @action
  _setDateRangeString() {
    dateRangeSelected = '${dateFormat.format(iniDate)} | ${dateFormat.format(endDate)}';
  }

  @action
  resetDateRange() async {
    iniDate = DateTime.now();
    endDate = DateTime.now();

    _setDateRangeString();
    await getOrderListBetweenDates();
  }

  @action
  getOrderListBetweenDates() async {
    loading = true;

    final result =
        await orderUsecase.getOrderListByEnabledBetweenDates(iniDate, endDate);

    result.fold((l) {
      error = optionOf(l);
      return;
    }, (r) {
      orderList = ObservableList.of(r);
      filteredOrderList = ObservableList.of(r);

      changeSortMethod();
    });

    loading = false;
  }

  @action
  changeSortMethod() {
    sortByDate = !sortByDate;

    sortByDate
        ? orderService.sortOrderListByClientName(orderList)
        : orderService.sortOrderListByRegistrationHour(orderList);
  }

  @action
  filterOrderListByText() {
    searchText = searchText.toLowerCase();
    filteredOrderList.clear();

    List<o.Order> auxList = [];

    for (o.Order i in orderList) {
      if (i.client.name.toLowerCase().contains(searchText) ||
          i.orderItemList.any((element) =>
              element.product.name.toLowerCase().contains(searchText) ||
              element.product.provider.name
                  .toLowerCase()
                  .contains(searchText))) {
        auxList.add(i);
      }
    }

    filteredOrderList = ObservableList.of(auxList);
  }

  @action
  callOrderRegistrationPage({
    required BuildContext context,
    required IOrderRegistrationPage registrationPage,
  }) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => registrationPage));

    await getOrderListBetweenDates();

    orderService.sortOrderListByRegistrationHour(orderList);
  }

  @action
  disableOrder(o.Order order) async {
    loading = true;

    final disableResult = await orderUsecase.disableOrder(order);

    disableResult.fold((l) => error = optionOf(l), (r) async {
      await getOrderListBetweenDates();
    });

    loading = false;
  }
}
