import '../../../../domain/entities/establishment.dart';

abstract class IEstablishmentService {
  void sortEstablishmentListByRegistrationDate(List<Establishment> estabList);
}
