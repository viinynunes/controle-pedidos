import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/establish_model.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/datasources/i_establishment_datasource.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/provider_model.dart';
import '../../firebase_helper_impl.dart';
import '../../provider/infra/datasources/i_provider_datasource.dart';

class EstablishmentFirebaseDatasourceImpl implements IEstablishmentDatasource {
    final firebase = FirebaseHelperImpl();

  @override
  Future<EstablishmentModel> createEstablishment(
      EstablishmentModel establishment) async {
    final rec = await firebase.getEstablishmentCollection()
        .add(establishment.toMap())
        .catchError((e) =>
            throw FirebaseException(plugin: 'CREATE ESTABLISHMENT ERROR'));

    establishment.id = rec.id;

    return await updateEstablishment(establishment);
  }

  @override
  Future<EstablishmentModel> updateEstablishment(
      EstablishmentModel establishment) async {
    firebase.getEstablishmentCollection()
        .doc(establishment.id)
        .update(establishment.toMap())
        .catchError(
          (e) => throw FirebaseException(plugin: 'UPDATE ESTABLISHMENT ERROR'),
        );

    FirebaseHelperImpl.firebaseDb.runTransaction((transaction) async {
      final establishmentRef = firebase.getEstablishmentCollection().doc(establishment.id);

      final providerSnap = await firebase.getProviderCollection()
          .where('establishment.id', isEqualTo: establishment.id)
          .get();

      for (var p in providerSnap.docs) {
        var provider = ProviderModel.fromMap(map: p.data());
        provider.establishment = establishment;

        GetIt.I.get<IProviderDatasource>().updateProvider(provider);
      }

      transaction.update(establishmentRef, establishment.toMap());
    }).catchError(
      (e) => throw FirebaseException(plugin: 'UPDATE ESTABLISHMENT ERROR'),
    );

    return establishment;
  }

  @override
  Future<EstablishmentModel> getEstablishmentById(String id) async {
    final snap = await firebase.getEstablishmentCollection().doc(id).get().catchError((e) =>
        throw FirebaseException(plugin: 'GET ESTABLISHMENT BY ID ERROR'));

    if (snap.data() == null) {
      throw FirebaseException(plugin: 'GET ESTABLISHMENT BY ID ERROR');
    }

    return EstablishmentModel.fromMap(map: snap.data()!);
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentList() async {
    List<EstablishmentModel> estabList = [];

    final snap =
        await firebase.getEstablishmentCollection().orderBy('name', descending: false).get();

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentListByEnabled() async {
    List<EstablishmentModel> estabList = [];

    final snap = await firebase.getEstablishmentCollection()
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get();

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }

  void moveToV2() async {
    final snap =
        await FirebaseFirestore.instance.collection('establishments').get();

    for (var p in snap.docs) {
      firebase.getEstablishmentCollection()
          .doc(p.id)
          .set(EstablishmentModel.fromMap(map: p.data()).toMap());
    }
  }
}
