import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/provider_data.dart';

class ProductData {
  ProductData();

  ProductData.fromDocSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get('name');
    category = snapshot.get('category');
    enabled = snapshot.get('enabled');
    provider = ProviderData.fromMap(snapshot.get('provider'));
  }

  ProductData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    category = map['category'];
    enabled = map['enabled'];
    provider = ProviderData.fromMap(map['provider']);
  }

  String? id;
  late String name;
  late String category;
  late bool enabled;

  late ProviderData provider;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'enabled': enabled,
      'provider': provider.toMap(),
    };
  }

  @override
  String toString() {
    return name + '  -  ' + category + '  -  ' + provider.name;
  }
}
