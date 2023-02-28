import 'dart:async';
import 'dart:developer';

import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/order/presenter/pages/i_order_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/admob/admob_helper.dart';
import '../../../../core/admob/services/ad_service.dart';
import '../../../../domain/entities/order.dart' as o;
import '../../../client/domain/usecases/i_client_usecase.dart';
import '../../../product/domain/usecases/i_product_usecase.dart';
import '../../../stock/domain/usecases/decrease_stock_total_usecase.dart';
import '../../errors/order_info_exception.dart';
import '../../services/i_order_service.dart';

part 'order_controller.g.dart';

class OrderController = _OrderControllerBase with _$OrderController;

abstract class _OrderControllerBase with Store {
  final IOrderService orderService;
  final IOrderUsecase orderUsecase;
  final DecreaseStockTotalUsecase decreaseStockTotalUsecase;
  final IProductUsecase productUsecase;
  final IClientUsecase clientUsecase;
  final AdService adService;
  final adHelper = AdMobHelper();

  _OrderControllerBase(
      this.orderUsecase,
      this.orderService,
      this.decreaseStockTotalUsecase,
      this.productUsecase,
      this.clientUsecase,
      this.adService);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  bool sortByDate = true;
  @observable
  Option<OrderInfoException> error = none();
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

  final ordersToShowAds = 3;
  int ordersToShowAdsLeft = 3;

  @action
  initState() async {
    resetActionsVars();
    await resetDateRange();

    await getProductList();
    await getClientList();
  }

  @action
  resetActionsVars() {
    loading = false;
    searching = false;
    searchText = '';
    orderList = ObservableList<o.Order>.of([]);
    filteredOrderList = ObservableList<o.Order>.of([]);
    error = none();
  }

  @action
  getProductList() async {
    loading = true;

    final result = await productUsecase.getProductListByEnabled();

    result.fold((l) => error = optionOf(OrderInfoException(l.message)),
        (r) => productList = ObservableList.of(r));

    loading = false;
  }

  @action
  getClientList() async {
    loading = true;

    final result = await clientUsecase.getClientEnabled();

    result.fold((l) => error = optionOf(OrderInfoException(l.message)),
        (r) => clientList = ObservableList.of(r));

    loading = false;
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
    dateRangeSelected =
        '${dateFormat.format(iniDate)} | ${dateFormat.format(endDate)}';
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

    resetActionsVars();
    await getOrderListBetweenDates();

    orderService.sortOrderListByRegistrationHour(orderList);

    adsHandler();
  }

  @action
  disableOrder(o.Order order) async {
    loading = true;

    final disableResult = await orderUsecase.disableOrder(order);

    for (var item in order.orderItemList) {
      await decreaseStockTotalUsecase(
          product: item.product,
          decreaseQuantity: item.quantity,
          date: order.registrationDate);
    }

    disableResult.fold((l) => error = optionOf(l), (r) async {
      await getOrderListBetweenDates();
    });

    loading = false;
  }

  bool showBannerAd() => adService.showBannerAd();

  adsHandler() async {
    ordersToShowAdsLeft--;
    log('New orders left to show ads $ordersToShowAdsLeft');

    if (ordersToShowAdsLeft == 0) { 
      adHelper.createInterstitialAd();

      await Future.delayed(const Duration(seconds: 1));

      adHelper.showInterstitialAd();
      resetOrderToShowAds();
    }
  }

  resetOrderToShowAds() {
    ordersToShowAdsLeft = ordersToShowAds;
    log('Reseting orders to show ads to $ordersToShowAds');
  }
}
