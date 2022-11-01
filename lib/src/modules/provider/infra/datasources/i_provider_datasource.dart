import '../models/provider_model.dart';

abstract class IProviderDatasource {
  Future<ProviderModel> createProvider(ProviderModel provider);

  Future<ProviderModel> updateProvider(ProviderModel provider);

  Future<List<ProviderModel>> getProviderList();

  Future<List<ProviderModel>> getProviderListByEnabled();
}
