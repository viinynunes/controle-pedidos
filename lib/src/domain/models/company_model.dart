import 'dart:convert';

import 'package:controle_pedidos/src/core/date_time_helper.dart';

import '../entities/company.dart';

class CompanyModel extends Company {
  CompanyModel(
      {required super.id,
      required super.name,
      required super.registrationDate});

  static CompanyModel fromMap({required Map<String, dynamic> map}) {
    return CompanyModel(
        id: map['id'],
        name: map['name'],
        registrationDate:
            DateTimeHelper.convertTimestampToDateTime(map['registrationDate']));
  }

  static CompanyModel fromResumedMap({required Map<String, dynamic> map}) {
    return CompanyModel(
        id: map['id'],
        name: map['name'],
        registrationDate: DateTime.now());
  }

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

  Map<String, dynamic> toResumedMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toJson() => json.encode(toResumedMap());

  static CompanyModel fromJson(String source) => fromResumedMap(map: json.decode(source));
}
