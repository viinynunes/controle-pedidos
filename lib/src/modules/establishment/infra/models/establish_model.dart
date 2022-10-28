import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';

import '../../../core/helpers.dart';

class EstablishmentModel extends Establishment {
  EstablishmentModel(
      {required super.id,
      required super.name,
      required super.registrationDate,
      required super.enabled});

  EstablishmentModel.fromEstablishment({required Establishment establishment})
      : super(
            id: establishment.id,
            name: establishment.name,
            registrationDate: establishment.registrationDate,
            enabled: establishment.enabled);

  EstablishmentModel.fromMap({required Map<String, dynamic> map})
      : super(
          id: map['id'],
          registrationDate: map['registrationDate'] is Timestamp
              ? Helpers.convertTimestampToDateTime(map['registrationDate'])
              : map['registrationDate'],
          name: map['name'],
          enabled: map['enabled'],
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'registrationDate': registrationDate,
      'enabled': enabled,
    };
  }

  Map<String, dynamic> toIdMap() {
    return {
      'id': id,
    };
  }
}
