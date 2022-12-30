import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entities/client.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/models/company_model.dart';
import '../../../modules/client/domain/usecases/i_client_usecase.dart';
import '../../../modules/client/errors/client_errors.dart';
import '../../../modules/company/infra/datasources/i_company_datasource.dart';
import '../../../modules/company/presenter/pages/android/android_company_details_page.dart';
import '../../../modules/login/domain/usecases/i_login_usecase.dart';
import '../../../modules/order/presenter/pages/android/android_order_list_page.dart';
import '../../../modules/product/domain/usecases/i_product_usecase.dart';
import '../../../modules/product/errors/product_error.dart';
import '../../../modules/stock/presenter/pages/android/android_stock_page.dart';
import '../../registration/android_registration_page.dart';
import '../../reports/android_reports_page.dart';

part 'home_page_controller.g.dart';

class HomePageController = _HomePageControllerBase with _$HomePageController;

abstract class _HomePageControllerBase with Store {
  final IProductUsecase productUsecase;
  final IClientUsecase clientUsecase;
  final ILoginUsecase loginUsecase;
  final ICompanyDatasource companyDatasource;

  _HomePageControllerBase(this.productUsecase, this.clientUsecase,
      this.loginUsecase, this.companyDatasource);

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

    final result = await loginUsecase.getLoggedUser();

    result.fold((l) => null, (r) {
      companyDatasource
          .saveLoggedCompany(CompanyModel.fromCompany(company: r.company));
    });

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
      const AndroidReportsPage(),
      const AndroidCompanyDetailsPage(),
    ];
  }
}
