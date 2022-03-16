import 'package:flutter/material.dart';

import '../data/provider_data.dart';
import '../model/provider_model.dart';
import '../pages/provider/provider_registration_page.dart';

class ProviderService {
  Future<ProviderData> createOrUpdate(
      {ProviderData? provider,
      required List<ProviderData> providerList,
      required BuildContext context}) async {

    final recProv = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProviderRegistrationPage(
                  provider: provider,
                )));

    if (recProv != null) {
      if (provider != null) {
        await ProviderModel.of(context).updateProvider(recProv);

        providerList.remove(provider);
        providerList.add(recProv);
      } else {
        ProviderModel.of(context).createProvider(recProv);
        providerList.add(recProv);
      }
    }

    return recProv;
  }

  void sortProviderListByName(List<ProviderData> providerList) {
    providerList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void sortProviderListByEstablishmentAndRegistration(
      List<ProviderData> providerList) {
    providerList.sort((a, b) {
      int compare = a.establishment.registrationDate
          .compareTo(b.establishment.registrationDate);

      if (compare == 0) {
        return a.registrationDate.compareTo(b.registrationDate);
      } else {
        return compare;
      }
    });
  }
}
