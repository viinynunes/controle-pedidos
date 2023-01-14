import 'package:controle_pedidos/src/domain/models/product_model.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';

import 'provider_mock.dart';

class ProductMock {
  static getOneProduct(
      {String productID = 'product01',
      String name = 'product name 001',
      String category = 'vs',
      bool enabled = true,
      bool stockDefault = false,
      ProviderModel? provider}) {
    return ProductModel(
        id: productID,
        name: name,
        category: category,
        enabled: enabled,
        stockDefault: stockDefault,
        provider: provider ?? ProviderMock.getOneProvider());
  }
}
