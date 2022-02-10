import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/client_data.dart';

class OrderData {
  OrderData({required this.client, required this.creationDate});

  OrderData.fromDocSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    creationDate = snapshot.get('creationDate');
    client = ClientData.fromMap(snapshot.get('client'));
  }

  OrderData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    creationDate = map['creationDate'];
    client = ClientData.fromMap(map['client']);
  }

  String? id;
  late DateTime creationDate;
  late ClientData client;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creationDate': creationDate,
      'client': client.toMap(),
    };
  }
}
