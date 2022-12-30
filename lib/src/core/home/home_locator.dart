import 'package:get_it/get_it.dart';

import 'stores/home_page_controller.dart';

final homeLocator = GetIt.instance;

void setUpHomeLocator() {
  homeLocator
      .registerSingleton(HomePageController(homeLocator(), homeLocator(), homeLocator(), homeLocator()));
}
