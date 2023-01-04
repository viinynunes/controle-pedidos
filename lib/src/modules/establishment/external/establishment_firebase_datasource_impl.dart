import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/establish_model.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/datasources/i_establishment_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/provider_model.dart';
import '../../firebase_helper_impl.dart';
import '../../provider/infra/datasources/i_provider_datasource.dart';

const cacheDocument = '00_cacheUpdated';

class EstablishmentFirebaseDatasourceImpl implements IEstablishmentDatasource {
  final firebase = FirebaseHelperImpl();

  @override
  Future<EstablishmentModel> createEstablishment(
      EstablishmentModel establishment) async {
    final rec = await firebase
        .getEstablishmentCollection()
        .add(establishment.toMap())
        .catchError((e) =>
            throw FirebaseException(plugin: 'CREATE ESTABLISHMENT ERROR'));

    establishment.id = rec.id;

    await _updateCacheDoc(DateTime.now());

    return await updateEstablishment(establishment);
  }

  @override
  Future<EstablishmentModel> updateEstablishment(
      EstablishmentModel establishment) async {
    FirebaseHelperImpl.firebaseDb.runTransaction((transaction) async {
      final establishmentRef =
          firebase.getEstablishmentCollection().doc(establishment.id);

      final cacheRef = firebase.getEstablishmentCollection().doc(cacheDocument);
      transaction.update(establishmentRef, establishment.toMap());
      transaction.update(cacheRef, {'updatedAt': DateTime.now()});

      final providerSnap = await firebase
          .getProviderCollection()
          .where('establishment.id', isEqualTo: establishment.id)
          .get();

      for (var p in providerSnap.docs) {
        var provider = ProviderModel.fromMap(map: p.data());
        provider.establishment = establishment;

        GetIt.I.get<IProviderDatasource>().updateProvider(provider);
      }
    }).catchError(
      (e) => throw FirebaseException(plugin: 'UPDATE ESTABLISHMENT ERROR'),
    );

    return establishment;
  }

  _updateCacheDoc(DateTime updatedAt) async {
    await firebase
        .getEstablishmentCollection()
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt});
  }

  @override
  Future<EstablishmentModel> getEstablishmentById(String id) async {
    final snap = await firebase
        .getEstablishmentCollection()
        .doc(id)
        .get()
        .catchError((e) =>
            throw FirebaseException(plugin: 'GET ESTABLISHMENT BY ID ERROR'));

    if (snap.data() == null) {
      throw FirebaseException(plugin: 'GET ESTABLISHMENT BY ID ERROR');
    }

    return EstablishmentModel.fromMap(map: snap.data()!);
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentList() async {
    List<EstablishmentModel> estabList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef =
        firebase.getEstablishmentCollection().doc(cacheDocument);

    final query = firebase
        .getEstablishmentCollection()
        .orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ESTABLISHMENT ERROR', message: e.toString()));

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentListByEnabled() async {
    List<EstablishmentModel> estabList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef =
        firebase.getEstablishmentCollection().doc(cacheDocument);

    final query = firebase
        .getEstablishmentCollection()
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
            plugin: 'GET ESTABLISHMENT ERROR', message: e.toString()));

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }

  void moveToV2() async {
    final snap =
        await FirebaseFirestore.instance.collection('establishments').get();

    for (var p in snap.docs) {
      firebase
          .getEstablishmentCollection()
          .doc(p.id)
          .set(EstablishmentModel.fromMap(map: p.data()).toMap());
    }
  }
}
