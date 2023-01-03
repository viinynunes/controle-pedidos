import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/modules/product/infra/datasources/i_product_datasource.dart';
import 'package:controle_pedidos/src/modules/provider/infra/datasources/i_provider_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/product_model.dart';
import '../../firebase_helper_impl.dart';

const cacheDocument = '00_cacheUpdated';

class ProviderFirebaseDatasourceImpl implements IProviderDatasource {
  final firebase = FirebaseHelperImpl();

  @override
  Future<ProviderModel> createProvider(ProviderModel provider) async {
    final result = await firebase.getProviderCollection().add(provider.toMap()).catchError(
        (e) => throw FirebaseException(plugin: 'CREATE PROVIDER ERROR'));

    provider.id = result.id;
    await updateProvider(provider);
    await _updateCacheDoc(DateTime.now());
    return provider;
  }

  @override
  Future<ProviderModel> updateProvider(ProviderModel provider) async {
    await firebase
        .getProviderCollection()
        .doc(provider.id)
        .update(provider.toMap())
        .catchError(
            (e) => throw FirebaseException(plugin: 'UPDATE PROVIDER ERROR'));

    FirebaseHelperImpl.firebaseDb.runTransaction((transaction) async {
      final providerRef = firebase.getProviderCollection().doc(provider.id);

      final productSnap = await firebase
          .getProductCollection()
          .where('provider.id', isEqualTo: provider.id)
          .get();

      for (var p in productSnap.docs) {
        var product = ProductModel.fromMap(map: p.data());
        product.provider = provider;

        GetIt.I.get<IProductDatasource>().updateProduct(product);
      }

      transaction.update(providerRef, provider.toMap());
    });

    await _updateCacheDoc(DateTime.now());

    return provider;
  }

  _updateCacheDoc(DateTime updatedAt) async {
    await firebase
        .getProviderCollection()
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt});
  }

  @override
  Future<ProviderModel> getProviderById(String id) async {
    final snap = await firebase
        .getProviderCollection()
        .doc(id)
        .get()
        .catchError(
            (e) => throw FirebaseException(plugin: 'GET PROVIDER ERROR'));

    if (snap.data() == null) {
      throw FirebaseException(plugin: 'PROVIDER NOT FOUND');
    }

    return ProviderModel.fromMap(map: snap.data()!);
  }

  @override
  Future<List<ProviderModel>> getProviderListByEnabled() async {
    List<ProviderModel> providerList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = firebase.getProviderCollection().doc(cacheDocument);

    final query = firebase
        .getProviderCollection()
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
        query: query,
        cacheDocRef: cacheDocRef,
        firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
        plugin: 'GET ESTABLISHMENT ERROR', message: e.toString()));

    for (var i in snap.docs) {
      providerList.add(ProviderModel.fromMap(map: i.data()));
    }

    return providerList;
  }

  @override
  Future<List<ProviderModel>> getProviderList() async {
    List<ProviderModel> providerList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = firebase.getProviderCollection().doc(cacheDocument);

    final query = firebase
        .getProviderCollection()
        .orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
        query: query,
        cacheDocRef: cacheDocRef,
        firestoreCacheField: cacheField)
        .catchError((e) => throw FirebaseException(
        plugin: 'GET ESTABLISHMENT ERROR', message: e.toString()));

    for (var i in snap.docs) {
      providerList.add(ProviderModel.fromMap(map: i.data()));
    }

    return providerList;
  }

  void moveToV2() async {
    final snap = await FirebaseFirestore.instance.collection('providers').get();

    for (var p in snap.docs) {
      firebase
          .getProviderCollection()
          .doc(p.id)
          .set(ProviderModel.fromMap(map: p.data()).toMap());
    }
  }
}
