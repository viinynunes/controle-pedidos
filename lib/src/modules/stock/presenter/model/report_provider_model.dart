import '../../../../domain/entities/stock.dart';

class ReportProviderModel {
  final String providerId;
  final String providerName;
  final String providerLocation;
  final List<Stock> stockList;
  bool merge;

  ReportProviderModel({
    required this.providerId,
    required this.providerName,
    required this.providerLocation,
    required this.stockList,
    required this.merge,
  });
}
