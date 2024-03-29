import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/modules/product/infra/datasources/i_product_datasource.dart';
import 'package:controle_pedidos/src/modules/provider/infra/datasources/i_provider_datasource.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/exceptions/external_exception.dart';
import '../../../domain/models/product_model.dart';

const cacheDocument = '00_cacheUpdated';

class ProviderFirebaseDatasourceImpl implements IProviderDatasource {
  final FirebaseFirestore firebase;
  late CollectionReference<Map<String, dynamic>> providerCollection;
  late CollectionReference<Map<String, dynamic>> productCollection;

  ProviderFirebaseDatasourceImpl({required this.firebase, String? companyID}) {
    providerCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('provider');

    productCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('product');
  }

  @override
  Future<ProviderModel> createProvider(ProviderModel provider) async {
    final result = await providerCollection.add(provider.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    provider.id = result.id;
    await updateProvider(provider);
    await _updateCacheDoc();
    return provider;
  }

  @override
  Future<ProviderModel> updateProvider(ProviderModel provider) async {
    await providerCollection.doc(provider.id).update(provider.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    _updateProduct(provider);

    _updateCacheDoc();

    return provider;
  }

  _updateProduct(ProviderModel provider) async {
    final productSnap = await productCollection
        .where('provider.id', isEqualTo: provider.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var p in productSnap.docs) {
      var product = ProductModel.fromMap(map: p.data());
      product.provider = provider;

      GetIt.I.get<IProductDatasource>().updateProduct(product);
    }
  }

  _updateCacheDoc({DateTime? updatedAt}) async {
    await providerCollection
        .doc(cacheDocument)
        .update({'updatedAt': updatedAt ?? DateTime.now()}).onError(
            (error, stackTrace) => throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));
  }

  @override
  Future<ProviderModel> getProviderById(String id) async {
    final snap = await providerCollection.doc(id).get().onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    if (snap.data() == null) {
      throw ExternalException(error: 'PROVIDER NOT FOUND');
    }

    return ProviderModel.fromDocumentSnapshot(doc: snap);
  }

  @override
  Future<List<ProviderModel>> getProviderListByEnabled() async {
    List<ProviderModel> providerList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = providerCollection.doc(cacheDocument);

    final query = providerCollection
        .where('enabled', isEqualTo: true)
        .orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var i in snap.docs) {
      providerList.add(ProviderModel.fromDocumentSnapshot(doc: i));
    }

    return providerList;
  }

  @override
  Future<List<ProviderModel>> getProviderList() async {
    List<ProviderModel> providerList = [];

    const cacheField = 'updatedAt';
    final cacheDocRef = providerCollection.doc(cacheDocument);

    final query = providerCollection.orderBy('name', descending: false);

    final snap = await FirestoreCache.getDocuments(
            query: query,
            cacheDocRef: cacheDocRef,
            firestoreCacheField: cacheField)
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var i in snap.docs) {
      providerList.add(ProviderModel.fromDocumentSnapshot(doc: i));
    }

    return providerList;
  }
}
