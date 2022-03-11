import '../data/provider_data.dart';

class ProviderService {
  void sortProviderListByName(List<ProviderData> providerList) {
    providerList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
