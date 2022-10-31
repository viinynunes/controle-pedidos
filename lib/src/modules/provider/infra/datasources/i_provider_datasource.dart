import 'package:controle_pedidos/src/modules/provider/domain/entities/provider.dart';

import '../models/provider_model.dart';

abstract class IProviderDatasource {
  Future<bool> createProvider(ProviderModel provider);

  Future<bool> updateProvider(ProviderModel provider);

  Future<List<Provider>> getProviderList();
}
