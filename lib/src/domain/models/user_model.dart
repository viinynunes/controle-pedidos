import '../entities/user.dart';
import 'company_model.dart';

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.fullName,
      required super.email,
      required super.phone,
      required super.company});

  UserModel.fromMap({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            fullName: map['fullName'],
            email: map['email'],
            phone: map['phone'],
            company: map['company']);

  UserModel.fromUser({required User user})
      : super(
            id: user.id,
            fullName: user.fullName,
            email: user.email,
            phone: user.phone,
            company: user.company);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'company': CompanyModel.fromCompany(company: company).toMap(),
    };
  }
}
