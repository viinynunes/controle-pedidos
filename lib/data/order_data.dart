import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';

class OrderData {
  OrderData();

  OrderData.fields(
      {required this.client,
      required this.creationDate,
      required this.creationHour,
      required this.lengthOrderItemList,
      required this.enabled,
      required this.orderItemList});

  OrderData.fromDocSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Timestamp timeDate = snapshot.get('creationDate');
    creationDate = DateTime.parse(timeDate.toDate().toString());
    Timestamp timeHour = snapshot.get('creationHour');
    creationHour = DateTime.parse(timeHour.toDate().toString());
    lengthOrderItemList = snapshot.get('lengthOrderItemList');
    client = ClientData.fromMap(snapshot.get('client'));
    enabled = snapshot.get('enabled');
  }

  OrderData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    creationDate = map['creationDate'];
    creationHour = map['creationHour'];
    client = ClientData.fromMap(map['client']);
    lengthOrderItemList = map['lengthOrderItemList'];
    enabled = map['enabled'];
    var itemListMap = map['orderItemList'];
    for (var e in itemListMap) {
      orderItemList!.add(OrderItemData.fromMap(e));
    }
  }

  String? id;
  late DateTime creationDate;
  late DateTime creationHour;
  late ClientData client;
  late int lengthOrderItemList;
  late bool enabled;

  List<OrderItemData>? orderItemList = [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creationDate': creationDate,
      'creationHour': creationHour,
      'enabled': enabled,
      'lengthOrderItemList': lengthOrderItemList,
      'client': client.toMap(),
      'orderItemList': orderItemList!.map((e) => e.toMap()),
    };
  }

  Map<String, dynamic> toResumedMap() {
    return {
      'id': id,
      'creationDate': creationDate,
      'creationHour': creationHour,
      'lengthOrderItemList': lengthOrderItemList,
      'enabled': enabled,
      'client': client.toMap(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is! OrderData) return false;

    return client.name == (other).client.name;
  }

  @override
  int get hashCode => id.hashCode;
}
