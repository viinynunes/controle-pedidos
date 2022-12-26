import 'package:controle_pedidos/src/modules/login/presenter/stores/login_controller.dart';
import 'package:get_it/get_it.dart';

final loginLocator = GetIt.instance;

void setUpLoginLocator() {
  loginLocator.registerFactory(() => LoginController());
}
