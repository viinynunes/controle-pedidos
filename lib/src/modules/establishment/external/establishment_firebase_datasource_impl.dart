import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/datasources/i_establishment_datasource.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/models/establish_model.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';

class EstablishmentFirebaseDatasourceImpl implements IEstablishmentDatasource {
  final _establishmentCollection =
      FirebaseHelper.firebaseCollection.collection('establishment');

  @override
  Future<bool> createEstablishment(EstablishmentModel establishment) async {
    _establishmentCollection.add(establishment.toMap()).then((value) {
      establishment.id = value.id;
      _establishmentCollection
          .doc(establishment.id)
          .update(establishment.toMap());
    }).catchError(
      (e) => throw FirebaseException(plugin: 'CREATE ESTABLISHMENT ERROR'),
    );

    return true;
  }

  @override
  Future<bool> updateEstablishment(EstablishmentModel establishment) async {
    _establishmentCollection
        .doc(establishment.id)
        .update(establishment.toMap())
        .catchError(
          (e) => throw FirebaseException(plugin: 'UPDATE ESTABLISHMENT ERROR'),
        );

    return true;
  }

  @override
  Future<EstablishmentModel> getEstablishmentById(String id) async {
    final snap = await _establishmentCollection.doc(id).get().catchError((e) =>
        throw FirebaseException(plugin: 'GET ESTABLISHMENT BY ID ERROR'));

    return EstablishmentModel.fromMap(map: snap.data()!);
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentList() async {
    List<EstablishmentModel> estabList = [];

    final snap =
        await _establishmentCollection.orderBy('name', descending: false).get();

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }

  @override
  Future<List<EstablishmentModel>> getEstablishmentListByEnabled() async {
    List<EstablishmentModel> estabList = [];

    final snap = await _establishmentCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get();

    for (var i in snap.docs) {
      estabList.add(EstablishmentModel.fromMap(map: i.data()));
    }

    return estabList;
  }
}
