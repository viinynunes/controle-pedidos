import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/models/company_model.dart';
import '../../../global_locator.dart';
import '../../../modules/company/infra/datasources/i_company_datasource.dart';
import '../../../modules/company/presenter/pages/android/android_company_details_page.dart';
import '../../../modules/login/domain/usecases/i_login_usecase.dart';
import '../../../modules/order/presenter/pages/android/android_order_list_page.dart';
import '../../../modules/stock/presenter/pages/android/android_stock_page.dart';
import '../../registration/android_registration_page.dart';
import '../../reports/android_reports_page.dart';

part 'home_page_controller.g.dart';

class HomePageController = _HomePageControllerBase with _$HomePageController;

abstract class _HomePageControllerBase with Store {
  final ILoginUsecase loginUsecase;
  final ICompanyDatasource companyDatasource;

  _HomePageControllerBase(this.loginUsecase, this.companyDatasource);

  @observable
  bool loading = false;
  @observable
  int bottomNavigationIndex = 0;

  late PageController pageController;

  @action
  initState() async {
    loading = true;

    final result = await loginUsecase.getLoggedUser();

    result.fold((l) => null, (r) {
      companyDatasource
          .saveLoggedCompany(CompanyModel.fromCompany(company: r.company));
    });

    await initGlobalServiceLocator();

    pageController = PageController();

    getBottomNavigationElements();
    loading = false;
  }

  @action
  changeIndex(int index) {
    bottomNavigationIndex = index;
  }

  List<Widget> getBottomNavigationElements() {
    return [
      const AndroidOrderListPage(),
      const AndroidStockPage(),
      const AndroidRegistrationsPage(),
      const AndroidReportsPage(),
      const AndroidCompanyDetailsPage(),
    ];
  }
}
