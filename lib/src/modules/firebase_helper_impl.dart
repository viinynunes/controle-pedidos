import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseHelperImpl {
  static final firebaseDb = FirebaseFirestore.instance;
  static final firebaseAuth = FirebaseAuth.instance;
  static final userCollection = firebaseDb.collection('user');
  static final companyCollection = firebaseDb.collection('company');

  getClientCollection() {
    return companyCollection
        .doc(GetStorage().read('companyID'))
        .collection('client');
  }

  getEstablishmentCollection() {
    return companyCollection
        .doc(GetStorage().read('companyID'))
        .collection('establishment');
  }

  getOrderCollection() {
    return companyCollection
        .doc(GetStorage().read('companyID'))
        .collection('order');
  }

  getProductCollection() {
    return companyCollection
        .doc(GetStorage().read('companyID'))
        .collection('product');
  }

  getProductOnOrderCollection() {
    return companyCollection
        .doc(GetStorage().read('companyID'))
        .collection('productOnOrder');
  }

  getProviderCollection() {
    return companyCollection
        .doc(GetStorage().read('companyID'))
        .collection('provider');
  }

  getStockCollection() {
    return companyCollection
        .doc(GetStorage().read('companyID'))
        .collection('stock');
  }
}
