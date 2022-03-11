import '../data/establishment_data.dart';

class EstablishmentService {
  void sortEstablishmentsByName(List<EstablishmentData> estabList) {
    estabList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
