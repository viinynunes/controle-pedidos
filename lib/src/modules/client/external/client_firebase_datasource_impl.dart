import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/client_model.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';

import '../../firebase_helper_impl.dart';

class ClientFirebaseDatasourceImpl implements IClientDatasource {
  final firebase = FirebaseHelperImpl();

  @override
  Future<ClientModel> createClient(ClientModel client) async {
    final result = await firebase.getClientCollection().add(client.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'CREATE CLIENT ERROR'));

    client.id = result.id;

    await updateClient(client);

    return client;
  }

  @override
  Future<ClientModel> updateClient(ClientModel client) async {
    final clientRef = firebase.getClientCollection().doc(client.id);
    FirebaseHelperImpl.firebaseDb.runTransaction((transaction) async {
      final orderSnap = await firebase
          .getOrderCollection()
          .where('client.id', isEqualTo: client.id)
          .get();

      for (var o in orderSnap.docs) {
        transaction.update(o.reference, {'client': client.toMap()});
      }

      transaction.update(clientRef, client.toMap());
    }).onError((error, stackTrace) => throw FirebaseException(
        plugin: 'UPDATE CLIENT ERROR', message: error.toString()));

    return client;
  }

  @override
  Future<bool> disableClient(ClientModel client) async {
    client.enabled = false;
    firebase.getClientCollection().doc(client.id).update(client.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'DISABLE CLIENT ERROR'));

    return true;
  }

  @override
  Future<ClientModel> getClientByID(String id) async {
    final snap = await firebase.getClientCollection().doc(id).get().catchError(
        (e) => throw FirebaseException(plugin: 'GET CLIENT BY ID ERROR'));

    return ClientModel.fromMap(snap.data()!);
  }

  @override
  Future<List<ClientModel>> getClientListByEnabled() async {
    List<ClientModel> clientList = [];

    final snap = await firebase.getClientCollection()
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get()
        .catchError((e) =>
            throw FirebaseException(plugin: 'GET CLIENT BY ENABLED ERROR'));

    for (var index in snap.docs) {
      clientList.add(ClientModel.fromMap(index.data()));
    }

    return clientList;
  }

  @override
  Future<List<ClientModel>> getClientList() async {
    List<ClientModel> clientList = [];

    final snap = await firebase.getClientCollection()
        .orderBy('name', descending: false)
        .get()
        .catchError((e) =>
            throw FirebaseException(plugin: 'GET CLIENT BY ENABLED ERROR'));

    for (var index in snap.docs) {
      clientList.add(ClientModel.fromMap(index.data()));
    }

    return clientList;
  }

  void moveToV2() async {
    final snap = await FirebaseFirestore.instance.collection('clients').get();

    for (var p in snap.docs) {
      firebase.getClientCollection().doc(p.id).set(ClientModel.fromMap(p.data()).toMap());
    }
  }
}
