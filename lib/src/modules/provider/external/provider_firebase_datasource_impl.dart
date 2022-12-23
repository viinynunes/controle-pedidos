import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';
import 'package:controle_pedidos/src/modules/product/infra/datasources/i_product_datasource.dart';
import 'package:controle_pedidos/src/modules/provider/infra/datasources/i_provider_datasource.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/product_model.dart';

class ProviderFirebaseDatasourceImpl implements IProviderDatasource {
  final _providerCollection = FirebaseHelper.providerCollection;

  @override
  Future<ProviderModel> createProvider(ProviderModel provider) async {
    final result = await _providerCollection.add({}).catchError(
        (e) => throw FirebaseException(plugin: 'CREATE PROVIDER ERROR'));

    provider.id = result.id;
    return await updateProvider(provider);
  }

  @override
  Future<ProviderModel> updateProvider(ProviderModel provider) async {
    await _providerCollection
        .doc(provider.id)
        .update(provider.toMap())
        .catchError(
            (e) => throw FirebaseException(plugin: 'UPDATE PROVIDER ERROR'));

    FirebaseHelper.firebaseDb.runTransaction((transaction) async {
      final providerRef = _providerCollection.doc(provider.id);

      final productSnap = await FirebaseHelper.productCollection
          .where('provider.id', isEqualTo: provider.id)
          .get();

      for (var p in productSnap.docs) {
        var product = ProductModel.fromMap(map: p.data());
        product.provider = provider;

        GetIt.I.get<IProductDatasource>().updateProduct(product);
      }

      transaction.update(providerRef, provider.toMap());
    });

    return provider;
  }

  @override
  Future<ProviderModel> getProviderById(String id) async {
    final snap = await _providerCollection.doc(id).get().catchError(
        (e) => throw FirebaseException(plugin: 'GET PROVIDER ERROR'));

    if (snap.data() == null) {
      throw FirebaseException(plugin: 'PROVIDER NOT FOUND');
    }

    return ProviderModel.fromMap(map: snap.data()!);
  }

  @override
  Future<List<ProviderModel>> getProviderListByEnabled() async {
    List<ProviderModel> providerList = [];

    final snap = await _providerCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false)
        .get()
        .catchError(
            (e) => throw FirebaseException(plugin: 'GET PROVIDER ERROR'));

    for (var i in snap.docs) {
      providerList.add(ProviderModel.fromMap(map: i.data()));
    }

    return providerList;
  }

  @override
  Future<List<ProviderModel>> getProviderList() async {
    List<ProviderModel> providerList = [];

    final snap = await _providerCollection
        .orderBy('name', descending: false)
        .get()
        .catchError(
            (e) => throw FirebaseException(plugin: 'GET PROVIDER ERROR'));

    for (var i in snap.docs) {
      providerList.add(ProviderModel.fromMap(map: i.data()));
    }

    return providerList;
  }

  void moveToV2() async {
    final snap = await FirebaseFirestore.instance.collection('providers').get();

    for (var p in snap.docs) {
      _providerCollection
          .doc(p.id)
          .set(ProviderModel.fromMap(map: p.data()).toMap());
    }
  }
}
