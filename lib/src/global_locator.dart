import 'package:controle_pedidos/src/modules/client/client_locator.dart';
import 'package:controle_pedidos/src/modules/establishment/establishment_locator.dart';
import 'package:get_it/get_it.dart';

import 'modules/core/drawer/drawer_locator.dart';
import 'modules/core/widgets/widgets_locator.dart';
import 'modules/product/product_locator.dart';
import 'modules/provider/provider_locator.dart';

final locator = GetIt.instance;

Future initGlobalServiceLocator() async {
  setUpWidgetsLocator();
  setUpDrawerLocator();
  setUpClientLocator();
  setUpEstablishmentLocator();
  setUpProviderLocator();
  setUpProductLocator();
}
