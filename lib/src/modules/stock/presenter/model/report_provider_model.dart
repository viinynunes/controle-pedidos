import '../../../../domain/entities/stock.dart';

class ReportProviderModel {
  final String providerId;
  final String providerName;
  final List<Stock> stockList;
  bool merge;

  ReportProviderModel({
    required this.providerId,
    required this.providerName,
    required this.stockList,
    required this.merge,
  });
}
