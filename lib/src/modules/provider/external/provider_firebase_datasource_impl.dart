import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';
import 'package:controle_pedidos/src/modules/provider/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/infra/datasources/i_provider_datasource.dart';
import 'package:controle_pedidos/src/modules/provider/infra/models/provider_model.dart';

class ProviderFirebaseDatasourceImpl implements IProviderDatasource {
  final _providerCollection =
      FirebaseHelper.firebaseCollection.collection('provider');

  @override
  Future<bool> createProvider(ProviderModel provider) async {
    _providerCollection.add({}).then((value) {
      provider.id = value.id;
      _providerCollection.doc(provider.id).update(provider.toMap());
    }).catchError(
        (e) => throw FirebaseException(plugin: 'CREATE PROVIDER ERROR'));

    return true;
  }

  @override
  Future<bool> updateProvider(ProviderModel provider) async {
    _providerCollection.doc(provider.id).update(provider.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'UPDATE PROVIDER ERROR'));

    return true;
  }

  @override
  Future<List<Provider>> getProviderList() async {
    List<ProviderModel> providerList = [];

    final snap =
        await _providerCollection.orderBy('name', descending: false).get();

    for (var i in snap.docs) {
      providerList.add(ProviderModel.fromMap(map: i.data()));
    }

    return providerList;
  }

  void moveToV2() async {
    final snap = await _providerCollection.get();

    for (var i in snap.docs) {
      _providerCollection.doc(i.id).update(
          ProviderModel.fromMapWithEstablishment(map: i.data())
              .toMapWithEstablishment());
    }
  }
}
