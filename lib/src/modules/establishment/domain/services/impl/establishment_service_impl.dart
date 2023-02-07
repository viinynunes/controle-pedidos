import '../../../../../domain/entities/establishment.dart';
import '../i_establishment_service.dart';

class EstablishmentServiceImpl implements IEstablishmentService {
  @override
  void sortEstablishmentListByRegistrationDate(List<Establishment> estabList) {
    estabList.sort((a, b) => a.registrationDate.compareTo(b.registrationDate));
  }
}
