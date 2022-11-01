import 'package:controle_pedidos/src/modules/core/helpers.dart';
import 'package:controle_pedidos/src/modules/provider/domain/entities/provider.dart';

import '../../../establishment/infra/models/establish_model.dart';

class ProviderModel extends Provider {
  ProviderModel(
      {required super.id,
      required super.name,
      required super.location,
      required super.registrationDate,
      required super.enabled,
      required super.establishmentId,
      required super.establishmentName,
      super.establishment});

  ProviderModel.fromProvider(Provider provider)
      : super(
            id: provider.id,
            name: provider.name,
            location: provider.location,
            registrationDate: provider.registrationDate,
            enabled: provider.enabled,
            establishmentId: provider.establishmentId,
            establishmentName: provider.establishmentName,
            establishment: provider.establishment);

  ProviderModel.fromMap({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            name: map['name'],
            location: map['location'],
            registrationDate:
                Helpers.convertTimestampToDateTime(map['registrationDate']),
            enabled: map['enabled'],
            establishmentId: map['establishmentId'],
            establishmentName: map['establishmentName']);

  ProviderModel.fromMapWithEstablishment({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            name: map['name'],
            location: map['location'],
            registrationDate:
                Helpers.convertTimestampToDateTime(map['registrationDate']),
            enabled: map['enabled'],
            establishmentId: map['establishmentId'],
            establishmentName: map['establishmentName'],
            establishment:
                EstablishmentModel.fromMap(map: map['establishment']));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'registrationDate': registrationDate,
      'enabled': enabled,
      'establishmentId': establishmentId,
      'establishmentName': establishmentName,
      'establishment': establishment != null
          ? EstablishmentModel.fromEstablishment(establishment: establishment!)
              .toIdMap()
          : '',
    };
  }

  Map<String, dynamic> toMapWithEstablishment() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'registrationDate': registrationDate,
      'enabled': enabled,
      'establishmentId': establishmentId,
      'establishmentName': establishmentName,
      'establishment':
          EstablishmentModel.fromEstablishment(establishment: establishment!)
              .toMap()
    };
  }

  Map<String, dynamic> toResumedMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return name + ' - ' + location + ' - ' + establishmentName;
  }
}
