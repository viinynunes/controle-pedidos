import 'company.dart';

class User {
  String id;
  String fullName;
  String email;
  String phone;

  Company company;

  User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.phone,
      required this.company});
}
