import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';

class ProductModel extends Product {
  ProductModel(
      {required super.id,
      required super.name,
      required super.category,
      required super.enabled,
      required super.stockDefault,
      required super.providerId,
      required super.providerName});

  ProductModel.fromMap({required Map<String, dynamic> map})
      : super(
            id: map['id'],
            name: map['name'],
            category: map['category'],
            enabled: map['enabled'],
            stockDefault: map['stockDefault'],
            providerId: map['providerId'],
            providerName: map['providerName']);

  ProductModel.fromProduct({required Product product})
      : super(
            id: product.id,
            name: product.name,
            category: product.category,
            enabled: product.enabled,
            stockDefault: product.stockDefault,
            providerId: product.providerId,
            providerName: product.providerName,
            provider: product.provider);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'enabled': enabled,
      'stockDefault': stockDefault,
      'providerId': providerId,
      'providerName': providerName,
      'provider':
          provider != null ? ProviderModel.fromProvider(provider!).toMap() : '',
    };
  }

  @override
  String toString() {
    return '$name - $category - $providerName';
  }
}
