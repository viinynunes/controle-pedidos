import '../entities/establishment.dart';
import 'report_provider_model.dart';

class ReportEstablishmentModel {
  final Establishment establishment;
  final List<ReportProviderModel> providerList;
  bool selected;

  ReportEstablishmentModel(
      {required this.establishment,
      required this.selected,
      required this.providerList});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportEstablishmentModel &&
          runtimeType == other.runtimeType &&
          establishment == other.establishment;

  @override
  int get hashCode => establishment.hashCode;

  @override
  String toString() {
    return establishment.name;
  }
}
