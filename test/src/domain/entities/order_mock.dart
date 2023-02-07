import 'package:controle_pedidos/src/domain/models/client_model.dart';
import 'package:controle_pedidos/src/domain/models/order_item_model.dart';
import 'package:controle_pedidos/src/domain/models/order_model.dart';

import 'client_mock.dart';
import 'order_item_mock.dart';

class OrderMock {
  static OrderModel getOneOrder(
      {String id = 'orderID001',
      DateTime? registrationDate,
      DateTime? registrationHour,
      bool enabled = true,
      ClientModel? client,
      List<OrderItemModel>? orderItemList}) {
    return OrderModel(
        id: id,
        registrationDate: registrationDate ?? DateTime.now(),
        registrationHour: registrationHour ?? DateTime.now(),
        enabled: enabled,
        client: client ?? ClientMock.getOneClient(),
        orderItemList: orderItemList ?? OrderItemMock.getOrderItemList());
  }
}
