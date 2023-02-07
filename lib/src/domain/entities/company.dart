import 'enums/company_subscription.dart';

class Company {
  String id;
  String name;
  DateTime registrationDate;
  CompanySubscription subscription;

  Company(
      {required this.id,
      required this.name,
      required this.registrationDate,
      required this.subscription});
}
