import '../entities/provider.dart';
import '../entities/stock.dart';

class ReportProviderModel {
  final Provider provider;
  final List<Stock> stockList;
  bool merge;

  ReportProviderModel({
    required this.provider,
    required this.stockList,
    required this.merge,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportProviderModel &&
          runtimeType == other.runtimeType &&
          provider == other.provider;

  @override
  int get hashCode => provider.hashCode;
}
