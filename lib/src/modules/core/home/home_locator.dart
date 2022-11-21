import 'package:controle_pedidos/src/modules/core/home/stores/home_page_controller.dart';
import 'package:get_it/get_it.dart';

final homeLocator = GetIt.instance;

void setUpHomeLocator() {
  homeLocator
      .registerSingleton(HomePageController(homeLocator(), homeLocator()));
}
