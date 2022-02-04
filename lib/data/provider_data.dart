import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/product_data.dart';

class ProviderData {
  ProviderData();

  ProviderData.fromDocSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get('name');
    location = snapshot.get('location');
    productList = snapshot.get('products');
    enabled = snapshot.get('enabled');
  }

  ProviderData.fromMap(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    location = map['location'];
    enabled = map['enabled'];
  }

  String? id;
  late String name;
  late String location;
  late bool enabled;

  late List<ProductData>? productList;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'enabled': enabled
    };
  }
}
