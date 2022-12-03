import '../../../../domain/entities/stock.dart';

class ReportProviderModel {
  final String providerId;
  final String providerName;
  final List<Stock> stockList;

  ReportProviderModel(
      {required this.providerId,
      required this.providerName,
      required this.stockList});
}
