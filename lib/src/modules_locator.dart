import 'modules/client/client_locator.dart';
import 'modules/establishment/establishment_locator.dart';
import 'modules/order/order_locator.dart';
import 'modules/product/product_locator.dart';
import 'modules/provider/provider_locator.dart';
import 'modules/stock/stock_locator.dart';

Future initModulesLocator() async {
  setUpClientLocator();
  setUpEstablishmentLocator();
  setUpProviderLocator();
  setUpProductLocator();
  setUpStockLocator();
  setUpOrderLocator();
}
