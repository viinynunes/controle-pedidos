import 'package:controle_pedidos/src/domain/entities/client.dart';

import 'order_item.dart';

class Order {
  String id;
  DateTime registrationDate;
  DateTime registrationHour;
  bool enabled;
  Client client;

  List<OrderItem> orderItemList = [];

  Order({
    required this.id,
    required this.registrationDate,
    required this.registrationHour,
    required this.enabled,
    required this.client,
    required this.orderItemList,
  });

  void addOrderItem(OrderItem item) {
    orderItemList.add(item);
  }

  void removeOrderItem(OrderItem item) {
    orderItemList.remove(item);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          client == other.client;

  @override
  int get hashCode => client.hashCode;
}
