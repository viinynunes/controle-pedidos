import '../models/establish_model.dart';

abstract class IEstablishmentDatasource {
  Future<bool> createEstablishment(EstablishmentModel establishment);

  Future<bool> updateEstablishment(EstablishmentModel establishment);

  Future<EstablishmentModel> getEstablishmentById(String id);

  Future<List<EstablishmentModel>> getEstablishmentList();

  Future<List<EstablishmentModel>> getEstablishmentListByEnabled();
}
