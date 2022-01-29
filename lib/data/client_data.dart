import 'package:cloud_firestore/cloud_firestore.dart';

class ClientData {
  ClientData(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address});

  ClientData.fromMap(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get('name');
    phone = snapshot.get('phone');
    email = snapshot.get('email');
    address = snapshot.get('address');
  }

  late String id;
  late String name;
  String? phone;
  String? email;
  String? address;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
