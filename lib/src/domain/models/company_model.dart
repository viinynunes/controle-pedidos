import 'package:controle_pedidos/src/core/helpers.dart';

import '../entities/company.dart';

class CompanyModel extends Company {
  CompanyModel(
      {required super.id,
      required super.name,
      required super.registrationDate});

  CompanyModel.fromMap({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            name: map['name'],
            registrationDate:
                Helpers.convertTimestampToDateTime(map['registrationDate']));

  CompanyModel.fromCompany({required Company company})
      : super(
            id: company.id,
            name: company.name,
            registrationDate: company.registrationDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'registrationDate': registrationDate,
    };
  }
}
