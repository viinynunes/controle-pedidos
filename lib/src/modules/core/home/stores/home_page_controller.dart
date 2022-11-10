import 'package:mobx/mobx.dart';

import '../../../order/presenter/pages/android/android_order_list_page.dart';
import '../../../stock/presenter/pages/android/android_stock_page.dart';

part 'home_page_controller.g.dart';

class HomePageController = _HomePageControllerBase with _$HomePageController;

abstract class _HomePageControllerBase with Store {
  @observable
  int bottomNavigationIndex = 0;

  final bottomNavigationElements = [
    const AndroidOrderListPage(),
    const AndroidStockPage(),
  ];
}
