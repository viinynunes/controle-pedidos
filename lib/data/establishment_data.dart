import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/provider_data.dart';

class EstablishmentData {

  EstablishmentData();

  EstablishmentData.fromDocSnapshot(DocumentSnapshot snapshot){
    id = snapshot.id;
    name = snapshot.get('name');
    providerList = snapshot.get('providers');
    enabled = snapshot.get('enabled');
  }

  EstablishmentData.fromMap(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    enabled = map['enabled'];
  }

  String? id;
  late String name;
  late bool enabled;

  late List<ProviderData> providerList;

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'enabled': enabled
    };
  }
}