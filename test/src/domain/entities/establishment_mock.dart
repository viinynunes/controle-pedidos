import 'package:controle_pedidos/src/domain/models/establish_model.dart';

class EstablishmentMock {
  static EstablishmentModel getOneEstablishment() {
    return EstablishmentModel(
        id: '12',
        name: 'Veiling',
        registrationDate: DateTime.now(),
        enabled: true);
  }
}
