import 'package:controle_pedidos/src/core/data/user_tips/services/user_tips_service.dart';
import 'package:get_it/get_it.dart';

import 'core/admob/services/ad_service.dart';
import 'core/admob/services/impl/ad_service_impl.dart';
import 'core/data/user_tips/services/user_tips_service_impl.dart';
import 'core/ui/user_tips/tipsController.dart';
import 'modules/client/client_locator.dart';
import 'modules/establishment/establishment_locator.dart';
import 'modules/order/order_locator.dart';
import 'modules/product/product_locator.dart';
import 'modules/provider/provider_locator.dart';
import 'modules/stock/stock_locator.dart';

final getIt = GetIt.instance;

Future initModulesLocator() async {
  getIt.registerSingleton<UserTipsService>(UserTipsServiceImpl());
  getIt.registerFactory<TipsController>(() => TipsController(getIt()));
  getIt.registerSingleton<AdService>(AdServiceImpl(getIt()));
  setUpClientLocator();
  setUpEstablishmentLocator();
  setUpProviderLocator();
  setUpProductLocator();
  setUpStockLocator();
  setUpOrderLocator();
}
