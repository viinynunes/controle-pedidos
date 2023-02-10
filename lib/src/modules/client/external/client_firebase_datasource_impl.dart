import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/client_model.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/exceptions/external_exception.dart';

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
    final result = await clientCollection.add(client.toMap()).onError(
        (e, s) => throw ExternalException(error: e.toString(), stackTrace: s));

    client.id = result.id;

    await updateClient(client);
    await _updateCacheDoc();

    return client;
  }

  @override
  Future<ClientModel> updateClient(ClientModel client) async {
    await clientCollection.doc(client.id).update(client.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    _updateOrder(client);

    _updateCacheDoc();
    return client;
  }

  _updateOrder(ClientModel client) async {
    final orderSnap = await orderCollection
        .where('client.id', isEqualTo: client.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var o in orderSnap.docs) {
      orderCollection.doc(o.id).update({'client': client.toMap()}).onError(
          (error, stackTrace) => throw ExternalException(
              error: error.toString(), stackTrace: stackTrace));
    }
  }

  _updateCacheDoc({DateTime? updatedAt}) async {
    await clientCollection
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt ?? DateTime.now()}).onError(
            (error, stackTrace) => throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }

  @override
  Future<bool> disableClient(ClientModel client) async {
    clientCollection.doc(client.id).update(client.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    await _updateCacheDoc();
    return true;
  }

  @override
  Future<ClientModel> getClientByID(String id) async {
    final snap = await clientCollection.doc(id).get().onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

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
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var index in snapCached.docs) {
      clientList.add(ClientModel.fromMap(index.data()));
    }

    return clientList;
  }
}
