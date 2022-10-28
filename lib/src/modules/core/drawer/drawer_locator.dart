import 'package:controle_pedidos/src/modules/core/drawer/stores/drawer_controller.dart';
import 'package:get_it/get_it.dart';

final drawerLocator = GetIt.instance;

void setUpDrawerLocator() {
  drawerLocator.registerLazySingleton<DrawerController>(() => DrawerController());
}
