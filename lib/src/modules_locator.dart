import 'package:get_it/get_it.dart';

import 'core/admob/services/ad_service.dart';
import 'core/admob/services/impl/ad_service_impl.dart';
import 'modules/client/client_locator.dart';
import 'modules/establishment/establishment_locator.dart';
import 'modules/order/order_locator.dart';
import 'modules/product/product_locator.dart';
import 'modules/provider/provider_locator.dart';
import 'modules/stock/stock_locator.dart';

final getIt = GetIt.instance;

Future initModulesLocator() async {
  getIt.registerSingleton<AdService>(AdServiceImpl(getIt()));
  setUpClientLocator();
  setUpEstablishmentLocator();
  setUpProviderLocator();
  setUpProductLocator();
  setUpStockLocator();
  setUpOrderLocator();
}
