import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/order/presenter/pages/i_order_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/order.dart' as o;
import '../../../client/domain/usecases/i_client_usecase.dart';
import '../../../product/domain/usecases/i_product_usecase.dart';
import '../../errors/order_error.dart';
import '../../services/i_order_service.dart';

part 'order_controller.g.dart';

class OrderController = _OrderControllerBase with _$OrderController;

abstract class _OrderControllerBase with Store {
  final IOrderService orderService;
  final IOrderUsecase orderUsecase;
  final IClientUsecase clientUsecase;
  final IProductUsecase productUsecase;

  _OrderControllerBase(this.orderUsecase, this.clientUsecase,
      this.productUsecase, this.orderService);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
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
  initState() async {
    changeDateRangeSelected(DateTime.now(), DateTime.now());
    if (productList.isEmpty || clientList.isEmpty) {
      await getProductListByEnabled();
      await getClientListByEnabled();
    }
  }

  @action
  changeDateRangeSelected(DateTime iniDate, DateTime endDate) async {
    this.iniDate = iniDate;
    this.endDate = endDate;

    dateRangeSelected =
        (dateFormat.format(iniDate) + ' | ' + dateFormat.format(endDate));

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

      orderService.sortOrderListByRegistrationHour(orderList);
    });

    loading = false;
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
              element.product.providerName
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
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => registrationPage,
    ));

    if (result != null && result is o.Order) {
      if (registrationPage.order != null) {
        orderList.remove(registrationPage.order);
      }

      orderList.add(result);
    }

    orderService.sortOrderListByRegistrationHour(orderList);
  }

  @action
  disableOrder(o.Order order) async {
    loading = true;

    final disableResult = await orderUsecase.disableOrder(order);

    disableResult.fold((l) => error = optionOf(l), (r) {
      orderList.remove(order);
      filteredOrderList.remove(order);
    });

    loading = false;
  }

  @action
  getProductListByEnabled() async {
    loading = true;

    final result = await productUsecase.getProductListByEnabled();

    result.fold((l) => error = optionOf(OrderError(l.message)),
        (r) => productList = ObservableList.of(r));

    loading = false;
  }

  @action
  getClientListByEnabled() async {
    loading = true;

    final result = await clientUsecase.getClientEnabled();

    result.fold((l) => error = optionOf(OrderError(l.message)),
        (r) => clientList = ObservableList.of(r));

    loading = false;
  }
}
