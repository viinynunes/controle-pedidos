import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/services/i_provider_service.dart';

class ProviderServiceImpl implements IProviderService {
  @override
  void sortProviderListByRegistrationDate(List<Provider> providerList) {
    providerList.sort((a, b) {
      return a.registrationDate.compareTo(b.registrationDate);
    });
  }

  @override
  void sortProviderListByName(List<Provider> providerList) {
    providerList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
