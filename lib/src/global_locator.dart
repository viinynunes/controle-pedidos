import 'core/drawer/drawer_locator.dart';
import 'core/home/home_locator.dart';
import 'core/widgets/widgets_locator.dart';
import 'modules/client/client_locator.dart';
import 'modules/company/company_locator.dart';
import 'modules/establishment/establishment_locator.dart';
import 'modules/login/login_locator.dart';
import 'modules/order/order_locator.dart';
import 'modules/product/product_locator.dart';
import 'modules/provider/provider_locator.dart';
import 'modules/stock/stock_locator.dart';

Future initGlobalServiceLocator() async {
  setUpCompanyLocator();
  setUpLoginLocator();
  setUpWidgetsLocator();
  setUpDrawerLocator();
  setUpClientLocator();
  setUpEstablishmentLocator();
  setUpProviderLocator();
  setUpProductLocator();
  setUpStockLocator();
  setUpOrderLocator();
  setUpHomeLocator();
}
