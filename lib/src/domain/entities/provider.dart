import 'establishment.dart';

class Provider {
  String id;
  String name;
  String location;
  DateTime registrationDate;
  bool enabled;

  Establishment establishment;

  Provider(
      {required this.id,
      required this.name,
      required this.location,
      required this.registrationDate,
      required this.enabled,
      required this.establishment});
}
