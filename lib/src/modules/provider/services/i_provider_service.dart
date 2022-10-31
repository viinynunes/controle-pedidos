import '../domain/entities/provider.dart';

abstract class IProviderService {
  void sortProviderListByRegistrationDate(
      List<Provider> providerList);

  void sortProviderListByName(List<Provider> providerList);
}
