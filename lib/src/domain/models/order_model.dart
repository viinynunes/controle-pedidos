import 'package:controle_pedidos/src/domain/models/order_item_model.dart';

import '../../core/helpers.dart';
import '../entities/order.dart';
import 'client_model.dart';

class OrderModel extends Order {
  OrderModel(
      {required super.id,
      required super.registrationDate,
      required super.registrationHour,
      required super.orderItemLength,
      required super.enabled,
      required super.client,
      required super.orderItemList});

  OrderModel.fromOrder({required Order order})
      : super(
            id: order.id,
            registrationDate: order.registrationDate,
            registrationHour: order.registrationHour,
            orderItemLength: order.orderItemLength,
            enabled: order.enabled,
            client: order.client,
            orderItemList: order.orderItemList);

  OrderModel.fromMap(
      {required Map<String, dynamic> map, required super.orderItemList})
      : super(
          id: map['id'],
          registrationDate:
              Helpers.convertTimestampToDateTime(map['registrationDate']),
          registrationHour:
              Helpers.convertTimestampToDateTime(map['registrationHour']),
          orderItemLength: map['orderItemLength'],
          enabled: map['enabled'],
          client: ClientModel.fromMap(map['client']),
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registrationDate': registrationDate,
      'registrationHour': registrationHour,
      'orderItemLength': orderItemLength,
      'enabled': enabled,
      'client': ClientModel.fromClient(client).toMap(),
      'orderItemList': orderItemList
          .map((item) => OrderItemModel.fromOrderItem(item: item).toMap())
          .toList()
    };
  }
}
