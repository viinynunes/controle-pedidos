import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/order/presenter/pages/i_order_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/order.dart' as o;
import '../../../client/domain/usecases/i_client_usecase.dart';
import '../../../product/domain/usecases/i_product_usecase.dart';
import '../../errors/order_error.dart';

part 'order_controller.g.dart';

class OrderController = _OrderControllerBase with _$OrderController;

abstract class _OrderControllerBase with Store {
  final IOrderUsecase orderUsecase;
  final IClientUsecase clientUsecase;
  final IProductUsecase productUsecase;

  _OrderControllerBase(
      this.orderUsecase, this.clientUsecase, this.productUsecase);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  DateTime selectedDate = DateTime.now();
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

  final searchFocus = FocusNode();

  @action
  initState() async {
    await getOrderListByDate();
    if (productList.isEmpty || clientList.isEmpty) {
      await getProductListByEnabled();
      await getClientListByEnabled();
    }
  }

  @action
  getOrderListByDate() async {
    loading = true;

    final result =
        await orderUsecase.getOrderListByEnabledAndDate(selectedDate);

    result.fold((l) {
      error = optionOf(l);
      return;
    }, (r) {
      orderList = ObservableList.of(r);
      filteredOrderList = ObservableList.of(r);
    });

    loading = false;
  }

  @action
  filterOrderListByText() {
    searchText = searchText.toLowerCase();
    filteredOrderList.clear();

    List<o.Order> auxList = [];

    for (o.Order i in orderList) {
      if (i.client.name.toLowerCase().contains(searchText)) {
        auxList.add(i);
      }
    }

    filteredOrderList = ObservableList.of(auxList);
  }

  @action
  changeSelectedDate(DateTime date) {
    selectedDate = date;
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
      orderList.add(result);
    }
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
