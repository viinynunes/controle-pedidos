import 'package:get_storage/get_storage.dart';

import '../../domain/entities/enums/company_subscription.dart';
import '../../domain/models/company_model.dart';

class GetStorageConfiguration {
  static Future<void> config() async {
    await GetStorage.init();

    final box = GetStorage();

    if (box.read('company') == null) {
      box.write(
          'company',
          CompanyModel(
                  id: 'aaa',
                  name: 'aaa',
                  registrationDate: DateTime.now(),
                  subscription: CompanySubscription.free)
              .toJson());
    }

    if (box.read('showOnboarding') == null) {
      box.write('showOnboarding', true);
    }

    if (box.read('showOrderReportTip') == null) {
      box.write('showOrderReportTip', true);
    }

    if (box.read('showStockReportByEstablishmentTip') == null) {
      box.write('showStockReportByEstablishmentTip', true);
    }

    if (box.read('showStockReportByProviderTip') == null) {
      box.write('showStockReportByProviderTip', true);
    }
  }
}
