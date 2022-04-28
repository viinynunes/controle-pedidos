import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ClientModel extends Model {
  bool isLoading = false;
  List<ClientData> clientList = [];

  static ClientModel of(BuildContext context) =>
      ScopedModel.of<ClientModel>(context);

  void createClient(ClientData client) {
    FirebaseFirestore.instance.collection('clients').add(client.toMap()).then((
        value) {
      client.id = value.id;
      updateClient(client);
    });
  }

  void updateClient(ClientData client) async {
    FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id)
        .update(client.toMap());
    
    final snap = await FirebaseFirestore.instance.collection('orders').where('client.id', isEqualTo: client.id).get();

    for(var o in snap.docs){
      var order = OrderData.fromDocSnapshot(o);
      order.client = client;
      FirebaseFirestore.instance.collection('orders').doc(order.id).update(order.toResumedMap());
    }
  }

  void disableClient(ClientData client) {
    client.enabled = false;
    FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id)
        .update(client.toMap());
  }

  Future<ClientData> getOneClient(String id) {
    return FirebaseFirestore.instance
        .collection('clients')
        .doc(id)
        .get()
        .then((value) => ClientData.fromDocSnapshot(value));
  }

  Future<List<ClientData>> getFilteredClients({String? search}) async {
    isLoading = true;
    List<ClientData> auxList = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('clients')
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get();
    if (search != null) {
      for (DocumentSnapshot e in snapshot.docs) {
        String name = e.get('name');
        if (name.toLowerCase().contains(search.toLowerCase())) {
          auxList.add(ClientData.fromDocSnapshot(e));
        }
      }
    } else {
      for (DocumentSnapshot e in snapshot.docs) {
        auxList.add(ClientData.fromDocSnapshot(e));
      }
    }
    clientList.clear();
    clientList.addAll(auxList);
    isLoading = false;
    notifyListeners();
    return auxList;
  }
}
