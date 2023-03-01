import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/core/onboarding/store/onboarding_controller.dart';
import 'package:controle_pedidos/src/core/onboarding/services/onboarding_service.dart';
import 'package:controle_pedidos/src/core/onboarding/services/onboarding_service_impl.dart';
import 'package:get_it/get_it.dart';

import 'core/drawer/drawer_locator.dart';
import 'core/home/home_locator.dart';
import 'core/widgets/widgets_locator.dart';
import 'modules/client/client_locator.dart';
import 'modules/company/company_locator.dart';
import 'modules/establishment/establishment_locator.dart';
import 'modules/login/login_locator.dart';
import 'modules/order/order_locator.dart';
import 'modules/product/product_locator.dart';
import 'modules/provider/provider_locator.dart';
import 'modules/stock/stock_locator.dart';
import 'modules_locator.dart';

Future initGlobalServiceLocator({bool initModules = true}) async {
  GetIt.instance.allowReassignment = true;
  GetIt.instance
      .registerFactory<FirebaseFirestore>(() => FirebaseFirestore.instance);
  GetIt.instance
      .registerLazySingleton<OnboardingService>(() => OnboardingServiceImpl());
  GetIt.instance.registerFactory<OnboardingController>(
      () => OnboardingController(GetIt.instance()));
  setUpCompanyLocator();
  setUpLoginLocator();
  setUpWidgetsLocator();
  setUpDrawerLocator();
  setUpHomeLocator();

  initModules ? initModulesLocator() : null;
}

Future unregisterGlobalServiceLocator() async {
  unregisterClientLocator();
  unregisterEstablishmentLocator();
  unregisterProviderLocator();
  unregisterProductLocator();
  unregisterStockLocator();
  unregisterOrderLocator();
}
