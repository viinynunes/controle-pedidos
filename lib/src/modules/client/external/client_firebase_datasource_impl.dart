import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';
import 'package:controle_pedidos/src/modules/client/infra/models/client_model.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';

class ClientFirebaseDatasourceImpl implements IClientDatasource {
  final _clientCollection =
      FirebaseHelper.firebaseCollection.collection('client');

  @override
  Future<bool> createClient(ClientModel client) async {
    _clientCollection.add(client.toMap()).then((value) {
      client.id = value.id;
      _clientCollection.doc(client.id).update(client.toMap());
    }).catchError(
      (e) => throw FirebaseException(plugin: 'CREATE CLIENT ERROR'),
    );

    return true;
  }

  @override
  Future<bool> updateClient(ClientModel client) async {
    _clientCollection.doc(client.id).update(client.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'UPDATE CLIENT ERROR'));

    return true;
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
}
