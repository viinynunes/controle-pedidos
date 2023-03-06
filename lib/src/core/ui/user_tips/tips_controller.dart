import '../../data/user_tips/services/user_tips_service.dart';

class TipsController {
  final UserTipsService tipsService;

  TipsController(this.tipsService);

  void disableOrderReportTip() {
    tipsService.disableOrderReportTip();
  }

  void disableStockReportByEstablishmentTip() {
    tipsService.disableStockReportByEstablishmentTip();
  }

  void disableStockReportByProviderTip() {
    tipsService.disableStockReportByProviderTip();
  }

  bool showOrderReportTip() => tipsService.showOrderReportTip();

  bool showStockReportByEstablishmentTip() =>
      tipsService.showStockReportByEstablishmentTip();

  bool showStockReportByProviderTip() =>
      tipsService.showStockReportByProviderTip();
}
