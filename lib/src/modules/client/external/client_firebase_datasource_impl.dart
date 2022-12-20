import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/client_model.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';

class ClientFirebaseDatasourceImpl implements IClientDatasource {
  final db = FirebaseFirestore.instance;

  final _clientCollection =
      FirebaseHelper.firebaseCollection.collection('client');

  @override
  Future<ClientModel> createClient(ClientModel client) async {
    final result = await _clientCollection.add({}).catchError(
        (e) => throw FirebaseException(plugin: 'CREATE CLIENT ERROR'));

    client.id = result.id;

    return await updateClient(client);
  }

  @override
  Future<ClientModel> updateClient(ClientModel client) async {
    final clientRef = _clientCollection.doc(client.id);
    db.runTransaction((transaction) async {
      final orderSnap = await FirebaseHelper.firebaseCollection
          .collection('order')
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
    _clientCollection.doc(client.id).update(client.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'DISABLE CLIENT ERROR'));

    return true;
  }

  @override
  Future<ClientModel> getClientByID(String id) async {
    final snap = await _clientCollection.doc(id).get().catchError(
        (e) => throw FirebaseException(plugin: 'GET CLIENT BY ID ERROR'));

    return ClientModel.fromMap(snap.data()!);
  }

  @override
  Future<List<ClientModel>> getClientListByEnabled() async {
    List<ClientModel> clientList = [];

    final snap = await _clientCollection
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

    final snap = await _clientCollection
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
      _clientCollection.doc(p.id).set(ClientModel.fromMap(p.data()).toMap());
    }
  }
}
