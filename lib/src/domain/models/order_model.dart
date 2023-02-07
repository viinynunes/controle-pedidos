import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/order_item_model.dart';

import '../../core/date_time_helper.dart';
import '../entities/order.dart';
import 'client_model.dart';

class OrderModel extends Order {
  OrderModel(
      {required super.id,
      required super.registrationDate,
      required super.registrationHour,
      required super.enabled,
      required super.client,
      required super.orderItemList});

  OrderModel.fromOrder({required Order order})
      : super(
            id: order.id,
            registrationDate: order.registrationDate,
            registrationHour: order.registrationHour,
            enabled: order.enabled,
            client: order.client,
            orderItemList: order.orderItemList);

  OrderModel.fromDocumentSnapshot({required DocumentSnapshot doc})
      : super(
            id: doc.id,
            registrationDate: DateTimeHelper.convertTimestampToDateTime(
                doc.get('registrationDate')),
            registrationHour: DateTimeHelper.convertTimestampToDateTime(
                doc.get('registrationHour')),
            enabled: doc.get('enabled'),
            client: ClientModel.fromMap(doc.get('client')),
            orderItemList: doc
                .get('orderItemList')
                .map<OrderItemModel>(
                    (item) => OrderItemModel.fromMap(map: item))
                .toList());

  OrderModel.fromMap({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            registrationDate: DateTimeHelper.convertTimestampToDateTime(
                map['registrationDate']),
            registrationHour: DateTimeHelper.convertTimestampToDateTime(
                map['registrationHour']),
            enabled: map['enabled'],
            client: ClientModel.fromMap(map['client']),
            orderItemList: map['orderItemList']
                .map<OrderItemModel>(
                    (item) => OrderItemModel.fromMap(map: item))
                .toList());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registrationDate': registrationDate,
      'registrationHour': registrationHour,
      'enabled': enabled,
      'client': ClientModel.fromClient(client).toMap(),
      'orderItemList': orderItemList
          .map((item) => OrderItemModel.fromOrderItem(item: item).toMap())
          .toList()
    };
  }

  @override
  String toString() {
    return '${client.name} - $registrationDate';
  }
}
