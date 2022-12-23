import 'package:mobx/mobx.dart';

part 'drawer_controller.g.dart';

class DrawerController = _DrawerControllerBase with _$DrawerController;

abstract class _DrawerControllerBase with Store {
  @observable
  String name = '';

  @observable
  String company = '';
}
