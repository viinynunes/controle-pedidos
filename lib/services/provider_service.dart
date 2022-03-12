import '../data/provider_data.dart';

class ProviderService {
  void sortProviderListByName(List<ProviderData> providerList) {
    providerList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void sortProviderListByEstablishmentAndRegistration(List<ProviderData> providerList) {
    providerList.sort((a, b) {
      int compare = a.establishment.registrationDate.compareTo(b.establishment.registrationDate);

      if (compare == 0){
        return a.registrationDate.compareTo(b.registrationDate);
      } else {
        return compare;
      }
    });
  }

}
