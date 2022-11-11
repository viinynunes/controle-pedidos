import 'package:mobx/mobx.dart';

import '../../../../domain/entities/order_item.dart';

part 'order_registration_tile_controller.g.dart';

class OrderRegistrationTileController = _OrderRegistrationTileControllerBase
    with _$OrderRegistrationTileController;

abstract class _OrderRegistrationTileControllerBase with Store {
  late OrderItem item;

  @observable
  int quantity = 0;

  @action
  initState(OrderItem item) {
    this.item = item;
    quantity = this.item.quantity;
  }

  @action
  updateQuantity(bool increase) {
    if (increase) {
      quantity++;
    } else {
      quantity--;
    }

    item.quantity = quantity;
  }
}
