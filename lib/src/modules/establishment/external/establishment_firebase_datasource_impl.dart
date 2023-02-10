import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/core/exceptions/external_exception.dart';
import 'package:controle_pedidos/src/domain/models/establish_model.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/datasources/i_establishment_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../../../domain/models/provider_model.dart';
import '../../provider/infra/datasources/i_provider_datasource.dart';

const cacheDocument = '00_cacheUpdated';

class EstablishmentFirebaseDatasourceImpl implements IEstablishmentDatasource {
  final FirebaseFirestore firebase;

  late CollectionReference<Map<String, dynamic>> establishmentCollection;
  late CollectionReference<Map<String, dynamic>> providerCollection;

  EstablishmentFirebaseDatasourceImpl(
      {required this.firebase, String? companyID}) {
    establishmentCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('establishment');

    providerCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('provider');
  }

  @override
  Future<EstablishmentModel> createEstablishment(
      EstablishmentModel establishment) async {
    final rec = await establishmentCollection
        .add(establishment.toMap())
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    establishment.id = rec.id;

    await _updateCacheDoc();

    return await updateEstablishment(establishment);
  }

  @override
  Future<EstablishmentModel> updateEstablishment(
      EstablishmentModel establishment) async {
    await establishmentCollection
        .doc(establishment.id)
        .update(establishment.toMap())
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    _updateProvider(establishment);

    _updateCacheDoc();

    return establishment;
  }

  _updateProvider(EstablishmentModel establishment) async {
    final providerSnap = await providerCollection
        .where('establishment.id', isEqualTo: establishment.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var p in providerSnap.docs) {
      var provider = ProviderModel.fromDocumentSnapshot(doc: p);
      provider.establishment = establishment;

      GetIt.I.get<IProviderDatasource>().updateProvider(provider);
    }
  }

  _updateCacheDoc({DateTime? updatedAt}) async {
    await establishmentCollection
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt ?? DateTime.now()}).onError(
            (error, stackTrace) => throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }

  @override
  Future<EstablishmentModel> getEstablishmentById(String id) async {
    final snap = await establishmentCollection.doc(id).get().onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    if (snap.data() == null) {
      throw ExternalException(error: 'GET Establishment by ID error');
    }

    return EstablishmentModel.fromMap(map: snap.data()!);
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentList() async {
    List<EstablishmentModel> estabList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = establishmentCollection.doc(cacheDocument);

    final query = establishmentCollection.orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentListByEnabled() async {
    List<EstablishmentModel> estabList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = establishmentCollection.doc(cacheDocument);

    final query = establishmentCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }
}
