import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/client_model.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_storage/get_storage.dart';

const cacheDocument = '00_cacheUpdated';

class ClientFirebaseDatasourceImpl implements IClientDatasource {
  final FirebaseFirestore firebase;

  late CollectionReference<Map<String, dynamic>> clientCollection;
  late CollectionReference<Map<String, dynamic>> orderCollection;

  ClientFirebaseDatasourceImpl({required this.firebase, String? companyID}) {
    clientCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('client');

    orderCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('order');
  }

  @override
  Future<ClientModel> createClient(ClientModel client) async {
    final result = await clientCollection.add(client.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'CREATE CLIENT ERROR', message: e.toString()));

    client.id = result.id;

    await updateClient(client);
    await _updateCacheDoc();

    return client;
  }

  @override
  Future<ClientModel> updateClient(ClientModel client) async {
    await clientCollection.doc(client.id).update(client.toMap()).onError(
        (error, stackTrace) => throw FirebaseException(
            plugin: 'UPDATE CLIENT ERROR', message: error.toString()));

    _updateOrder(client);

    _updateCacheDoc();
    return client;
  }

  _updateOrder(ClientModel client) async {
    final orderSnap =
        await orderCollection.where('client.id', isEqualTo: client.id).get();

    for (var o in orderSnap.docs) {
      orderCollection.doc(o.id).update({'client': client.toMap()});
    }
  }

  _updateCacheDoc({DateTime? updatedAt}) async {
    await clientCollection
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt ?? DateTime.now()});
  }

  @override
  Future<bool> disableClient(ClientModel client) async {
    client.enabled = false;
    clientCollection.doc(client.id).update(client.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'DISABLE CLIENT ERROR', message: e.toString()));

    await _updateCacheDoc();
    return true;
  }

  @override
  Future<ClientModel> getClientByID(String id) async {
    final snap = await clientCollection.doc(id).get().catchError((e) =>
        throw FirebaseException(
            plugin: 'GET CLIENT BY ID ERROR', message: e.toString()));

    return ClientModel.fromMap(snap.data()!);
  }

  @override
  Future<List<ClientModel>> getClientListByEnabled() async {
    List<ClientModel> clientList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = clientCollection.doc(cacheDocument);
    final query = clientCollection
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
    final cacheDocRef = clientCollection.doc(cacheDocument);
    final query = clientCollection.orderBy('name', descending: false);
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
      clientCollection.doc(p.id).set(ClientModel.fromMap(p.data()).toMap());
    }
  }
}
