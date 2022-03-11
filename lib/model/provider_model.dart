import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProviderModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('providers');

  bool isLoading = false;

  static ProviderModel of(BuildContext context) =>
      ScopedModel.of<ProviderModel>(context);

  void createProvider(ProviderData provider) {
    isLoading = true;
    firebaseCollection.doc().set(provider.toMap());
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProvider(ProviderData provider) async {
    isLoading = true;
    await firebaseCollection.doc(provider.id).update(provider.toMap());
    isLoading = false;
    notifyListeners();
  }

  void disableProvider(ProviderData provider) {
    isLoading = true;
    provider.enabled = false;
    firebaseCollection.doc(provider.id).update(provider.toMap());
    isLoading = false;
    notifyListeners();
  }

  Future<List<ProviderData>> getEnabledProviders() async {
    isLoading = true;
    List<ProviderData> providerList = [];
    final snapshot = await firebaseCollection
        .orderBy('name', descending: false)
        .where('enabled', isEqualTo: true)
        .get();

    for (DocumentSnapshot e in snapshot.docs) {
      providerList.add(ProviderData.fromDocSnapshot(e));
    }
    isLoading = false;
    notifyListeners();
    return providerList;
  }

  Future<List<ProviderData>> getAllProviders() async {
    isLoading = true;
    List<ProviderData> providerList = [];
    final snapshot =
        await firebaseCollection.orderBy('name', descending: false).get();

    for (DocumentSnapshot e in snapshot.docs) {
      providerList.add(ProviderData.fromDocSnapshot(e));
    }
    isLoading = false;
    notifyListeners();
    return providerList;
  }
}
