import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeHelper {
  static DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static bool compareOnlyDateFromDateTime(
      DateTime firstDate, DateTime lastLate) {
    firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day);
    lastLate = DateTime(lastLate.year, lastLate.month, lastLate.day);

    return firstDate == lastLate;
  }

  static DateTime removeHourFromDateTime({required DateTime date}) {
    return DateTime(date.year, date.month, date.day);
  }
}
