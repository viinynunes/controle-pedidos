import 'package:controle_pedidos/src/modules/client/client_locator.dart';
import 'package:controle_pedidos/src/modules/establishment/establishment_locator.dart';

import 'modules/core/drawer/drawer_locator.dart';
import 'modules/core/home/home_locator.dart';
import 'modules/core/widgets/widgets_locator.dart';
import 'modules/order/order_locator.dart';
import 'modules/product/product_locator.dart';
import 'modules/provider/provider_locator.dart';
import 'modules/stock/stock_locator.dart';

Future initGlobalServiceLocator() async {
  setUpHomeLocator();
  setUpWidgetsLocator();
  setUpDrawerLocator();
  setUpClientLocator();
  setUpEstablishmentLocator();
  setUpProviderLocator();
  setUpProductLocator();
  setUpStockLocator();
  setUpOrderLocator();

}
