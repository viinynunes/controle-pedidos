import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/client_model.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';

import '../../firebase_helper_impl.dart';

const cacheDocument = '00_cacheUpdated';

class ClientFirebaseDatasourceImpl implements IClientDatasource {
  final firebase = FirebaseHelperImpl();

  @override
  Future<ClientModel> createClient(ClientModel client) async {
    final result = await firebase
        .getClientCollection()
        .add(client.toMap())
        .catchError((e) => throw FirebaseException(
            plugin: 'CREATE CLIENT ERROR', message: e.toString()));

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

    await _updateCacheDoc(DateTime.now());
    return client;
  }

  _updateCacheDoc(DateTime updatedAt) async {
    await firebase
        .getClientCollection()
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt});
  }

  @override
  Future<bool> disableClient(ClientModel client) async {
    client.enabled = false;
    firebase
        .getClientCollection()
        .doc(client.id)
        .update(client.toMap())
        .catchError((e) => throw FirebaseException(
            plugin: 'DISABLE CLIENT ERROR', message: e.toString()));

    await _updateCacheDoc(DateTime.now());
    return true;
  }

  @override
  Future<ClientModel> getClientByID(String id) async {
    final snap = await firebase.getClientCollection().doc(id).get().catchError(
        (e) => throw FirebaseException(
            plugin: 'GET CLIENT BY ID ERROR', message: e.toString()));

    return ClientModel.fromMap(snap.data()!);
  }

  @override
  Future<List<ClientModel>> getClientListByEnabled() async {
    List<ClientModel> clientList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = firebase.getClientCollection().doc(cacheDocument);
    final query = firebase
        .getClientCollection()
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false);
    final snapCached = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET CLIENT BY ENABLED ERROR', message: e.toString()));

    for (var index in snapCached.docs) {
      clientList.add(ClientModel.fromMap(index.data()));
    }

    return clientList;
  }

  @override
  Future<List<ClientModel>> getClientList() async {
    List<ClientModel> clientList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = firebase.getClientCollection().doc(cacheDocument);
    final query =
        firebase.getClientCollection().orderBy('name', descending: false);
    final snapCached = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET CLIENT BY ENABLED ERROR', message: e.toString()));

    for (var index in snapCached.docs) {
      clientList.add(ClientModel.fromMap(index.data()));
    }

    return clientList;
  }

  void moveToV2() async {
    final snap = await FirebaseFirestore.instance.collection('clients').get();

    for (var p in snap.docs) {
      firebase
          .getClientCollection()
          .doc(p.id)
          .set(ClientModel.fromMap(p.data()).toMap());
    }
  }
}
