import 'package:get_storage/get_storage.dart';

import 'user_tips_service.dart';

class UserTipsServiceImpl implements UserTipsService {
  final box = GetStorage();

  @override
  void disableOrderReportTip() {
    box.write('showOrderReportTip', false);
  }

  @override
  void disableStockReportByEstablishmentTip() {
    box.write('showStockReportByEstablishmentTip', false);
  }

  @override
  void disableStockReportByProviderTip() {
    box.write('showStockReportByProviderTip', false);
  }

  @override
  bool showOrderReportTip() {
    return box.read('showOrderReportTip') as bool;
  }

  @override
  bool showStockReportByEstablishmentTip() {
    return box.read('showStockReportByEstablishmentTip') as bool;
  }

  @override
  bool showStockReportByProviderTip() {
    return box.read('showStockReportByProviderTip') as bool;
  }
}
