import 'package:controle_pedidos/src/domain/entities/provider.dart';

class Product {
  String id;
  String name;
  String category;
  bool enabled;
  bool stockDefault;
  String providerId;
  String providerName;

  Provider? provider;

  Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.enabled,
      required this.stockDefault,
      required this.providerId,
      required this.providerName,
      this.provider});
}
