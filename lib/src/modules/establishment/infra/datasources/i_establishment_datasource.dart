import '../../../../domain/models/establish_model.dart';

abstract class IEstablishmentDatasource {
  Future<EstablishmentModel> createEstablishment(EstablishmentModel establishment);

  Future<EstablishmentModel> updateEstablishment(EstablishmentModel establishment);

  Future<EstablishmentModel> getEstablishmentById(String id);

  Future<List<EstablishmentModel>> getEstablishmentList();

  Future<List<EstablishmentModel>> getEstablishmentListByEnabled();
}
