import '../models/establish_model.dart';

abstract class IEstablishmentDatasource {
  Future<bool> createEstablishment(EstablishmentModel establishment);

  Future<bool> updateEstablishment(EstablishmentModel establishment);

  Future<List<EstablishmentModel>> getEstablishmentList();
}
