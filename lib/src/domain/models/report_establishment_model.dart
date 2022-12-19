import 'report_provider_model.dart';

class ReportEstablishmentModel {
  final String establishmentId;
  final String establishmentName;
  final List<ReportProviderModel> providerList;
  bool selected;

  ReportEstablishmentModel(
      {required this.establishmentId,
      required this.establishmentName,
      required this.selected,
      required this.providerList});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportEstablishmentModel &&
          runtimeType == other.runtimeType &&
          establishmentId == other.establishmentId;

  @override
  int get hashCode => establishmentId.hashCode;
}
