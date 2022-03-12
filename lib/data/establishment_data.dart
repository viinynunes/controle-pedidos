import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/provider_data.dart';

class EstablishmentData {
  EstablishmentData();

  EstablishmentData.fromDocSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get('name');
    Timestamp timestamp = snapshot.get('registrationDate');
    registrationDate = DateTime.parse(timestamp.toDate().toString());
    enabled = snapshot.get('enabled');
  }

  EstablishmentData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    Timestamp timestamp = map['registrationDate'];
    registrationDate = DateTime.parse(timestamp.toDate().toString());
    enabled = map['enabled'];
  }

  String? id;
  late String name;
  late DateTime registrationDate;
  late bool enabled;

  late List<ProviderData>? providerList;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'registrationDate': registrationDate,
      'enabled': enabled,
    };
  }

  @override
  String toString() {
    return name;
  }
}
