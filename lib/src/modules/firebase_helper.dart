import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static final firebaseCollection = FirebaseFirestore.instance.collection('v2').doc('version2');
}
