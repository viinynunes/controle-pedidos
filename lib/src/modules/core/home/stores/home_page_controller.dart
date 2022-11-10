import 'package:controle_pedidos/src/modules/core/registration/android_registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../../order/presenter/pages/android/android_order_list_page.dart';
import '../../../stock/presenter/pages/android/android_stock_page.dart';

part 'home_page_controller.g.dart';

class HomePageController = _HomePageControllerBase with _$HomePageController;

abstract class _HomePageControllerBase with Store {
  @observable
  int bottomNavigationIndex = 0;

  late PageController pageController;

  final bottomNavigationElements = [
    const AndroidOrderListPage(),
    const AndroidStockPage(),
    const AndroidRegistrationsPage(),
  ];

  @action
  initState(){
    pageController = PageController();
  }

  @action
  changeIndex(int index){
    bottomNavigationIndex = index;
  }
}
