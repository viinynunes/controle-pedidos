import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/entities/provider.dart';

import '../../core/date_time_helper.dart';
import 'establish_model.dart';

class ProviderModel extends Provider {
  ProviderModel(
      {required super.id,
      required super.name,
      required super.location,
      required super.registrationDate,
      required super.enabled,
      required super.establishment});

  ProviderModel.fromProvider(Provider provider)
      : super(
            id: provider.id,
            name: provider.name,
            location: provider.location,
            registrationDate: provider.registrationDate,
            enabled: provider.enabled,
            establishment: provider.establishment);

  ProviderModel.fromMap({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            name: map['name'],
            location: map['location'],
            registrationDate: DateTimeHelper.convertTimestampToDateTime(
                map['registrationDate']),
            enabled: map['enabled'],
            establishment:
                EstablishmentModel.fromMap(map: map['establishment']));

  ProviderModel.fromDocumentSnapshot({required DocumentSnapshot doc})
      : super(
            id: doc.id,
            name: doc.get('name'),
            location: doc.get('location'),
            registrationDate: DateTimeHelper.convertTimestampToDateTime(
                doc.get('registrationDate')),
            enabled: doc.get('enabled'),
            establishment:
                EstablishmentModel.fromMap(map: doc.get('establishment')));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'registrationDate': registrationDate,
      'enabled': enabled,
      'establishment':
          EstablishmentModel.fromEstablishment(establishment: establishment)
              .toMap()
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return name + ' - ' + location + ' - ' + establishment.name;
  }
}
