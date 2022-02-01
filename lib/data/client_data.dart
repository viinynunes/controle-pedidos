import 'package:cloud_firestore/cloud_firestore.dart';

class ClientData {

  ClientData.empty();

  ClientData(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address});

  ClientData.fromDocSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get('name');
    phone = snapshot.get('phone');
    email = snapshot.get('email');
    address = snapshot.get('address');
  }

  ClientData.fromMap(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
    email = map['email'];
    address = map['address'];
  }

  String? id;
  late String name;
  String? phone;
  String? email;
  String? address;
  bool? enabled;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'enabled': enabled
    };
  }
}
