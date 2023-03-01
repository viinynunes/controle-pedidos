import 'package:get_storage/get_storage.dart';

import '../../domain/entities/enums/company_subscription.dart';
import '../../domain/models/company_model.dart';

class GetStorageConfiguration {
  static Future<void> config() async {
    await GetStorage.init();

    if (GetStorage().read('company') == null) {
      GetStorage().write(
          'company',
          CompanyModel(
                  id: 'aaa',
                  name: 'aaa',
                  registrationDate: DateTime.now(),
                  subscription: CompanySubscription.free)
              .toJson());
    }

    if (GetStorage().read('showOnboarding') == null) {
      GetStorage().write('showOnboarding', true);
    }
  }
}
