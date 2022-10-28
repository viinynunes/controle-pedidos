import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';

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

  EstablishmentModel.fromMap(
      {required Map<String, dynamic> map, required super.registrationDate})
      : super(
          id: map['id'],
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
}
