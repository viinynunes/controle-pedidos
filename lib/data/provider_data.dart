import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:controle_pedidos/data/product_data.dart';

class ProviderData {
  ProviderData();

  ProviderData.fromDocSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get('name');
    location = snapshot.get('location');
    enabled = snapshot.get('enabled');
    establishment = EstablishmentData.fromMap(snapshot.get('establishment'));
  }

  ProviderData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    location = map['location'];
    enabled = map['enabled'];
    establishment = EstablishmentData.fromMap(map['establishment']);
  }

  String? id;
  late String name;
  late String location;
  late bool enabled;

  EstablishmentData? establishment;

  List<ProductData>? productList;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'enabled': enabled,
      'establishment': establishment?.toMap()
    };
  }

  @override
  bool operator ==(Object other) {
    if(other is! ProviderData){
      return false;
    }
    return name == (other).name;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    // TODO: implement toString
    return '$name - $location';
  }
}
