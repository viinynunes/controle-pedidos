import 'package:controle_pedidos/src/modules/client/client_locator.dart';
import 'package:controle_pedidos/src/modules/establishment/establishment_locator.dart';
import 'package:get_it/get_it.dart';

import 'modules/core/drawer/drawer_locator.dart';

final locator = GetIt.instance;

Future initGlobalServiceLocator() async {
  setUpDrawerLocator();
  setUpClientLocator();
  setUpEstablishmentLocator();
}
