import 'package:controle_pedidos/src/modules/client/client_locator.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void initGlobalServiceLocator() {
  setUpClientLocator();
}
