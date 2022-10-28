import 'package:cloud_firestore/cloud_firestore.dart';

class Helpers {
  static DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }
}
