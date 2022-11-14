import 'package:controle_pedidos/src/modules/client/domain/usecases/i_client_usecase.dart';
import 'package:controle_pedidos/src/modules/core/registration/android_registration_page.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/i_product_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/client.dart';
import '../../../../domain/entities/product.dart';
import '../../../client/errors/client_errors.dart';
import '../../../order/presenter/pages/android/android_order_list_page.dart';
import '../../../product/errors/product_error.dart';
import '../../../stock/presenter/pages/android/android_stock_page.dart';

part 'home_page_controller.g.dart';

class HomePageController = _HomePageControllerBase with _$HomePageController;

abstract class _HomePageControllerBase with Store {
  final IOrderUsecase orderUsecase;
  final IProductUsecase productUsecase;
  final IClientUsecase clientUsecase;

  _HomePageControllerBase(
      this.orderUsecase, this.productUsecase, this.clientUsecase);

  @observable
  bool loading = false;
  @observable
  int bottomNavigationIndex = 0;
  @observable
  Option<ProductError> productError = none();
  @observable
  Option<ClientError> clientError = none();

  List<Product> productList = [];
  List<Client> clientList = [];

  late PageController pageController;

  @action
  initState() async {
    loading = true;
    pageController = PageController();
    if (productList.isEmpty || clientList.isEmpty) {
      await getClientListByEnabled();
      await getProductListByEnabled();
    }
    getBottomNavigationElements();
    loading = false;
  }

  @action
  changeIndex(int index) {
    bottomNavigationIndex = index;
  }

  @action
  getProductListByEnabled() async {
    loading = true;

    final result = await productUsecase.getProductListByEnabled();

    result.fold((l) => productError = optionOf(l),
        (r) => productList = ObservableList.of(r));

    loading = false;
  }

  @action
  getClientListByEnabled() async {
    loading = true;

    final result = await clientUsecase.getClientEnabled();

    result.fold((l) => clientError = optionOf(l),
        (r) => clientList = ObservableList.of(r));

    loading = false;
  }

  List<Widget> getBottomNavigationElements() {
    return [
      AndroidOrderListPage(
        productList: productList,
        clientList: clientList,
      ),
      AndroidStockPage(
        productList: productList,
      ),
      const AndroidRegistrationsPage(),
    ];
  }
}
