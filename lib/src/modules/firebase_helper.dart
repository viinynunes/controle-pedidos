import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static final firebaseDb = FirebaseFirestore.instance;
  static final firebaseCompany = firebaseDb.collection('company').doc('JifXJRp03H9Sgj1pNHzQ');
  static final clientCollection = firebaseCompany.collection('client');
  static final productCollection = firebaseCompany.collection('product');
  static final providerCollection = firebaseCompany.collection('provider');
  static final establishmentCollection = firebaseCompany.collection('establishment');
  static final stockCollection = firebaseCompany.collection('stock');
  static final orderCollection = firebaseCompany.collection('order');


}
