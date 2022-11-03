import '../entities/client.dart';

class ClientModel extends Client {
  ClientModel(
      {required super.id,
      required super.name,
      required super.phone,
      required super.email,
      required super.address,
      required super.enabled});

  ClientModel.fromMap(Map<String, dynamic> map)
      : super(
            id: map['id'],
            name: map['name'],
            phone: map['phone'],
            email: map['email'],
            address: map['address'],
            enabled: map['enabled']);

  ClientModel.fromClient(Client client)
      : super(
            id: client.id,
            name: client.name,
            phone: client.phone,
            email: client.email,
            address: client.address,
            enabled: client.enabled);

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

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Client &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          email == other.email &&
          address == other.address &&
          enabled == other.enabled;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      address.hashCode ^
      enabled.hashCode;
}
