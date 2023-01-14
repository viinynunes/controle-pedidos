import 'package:controle_pedidos/src/domain/models/provider_model.dart';

import 'establishment_mock.dart';

class ProviderMock {
  static ProviderModel getOneProvider() {
    return ProviderModel(
        id: '4',
        name: 'Odair',
        location: 'Box G58',
        registrationDate: DateTime.now(),
        enabled: true,
        establishment: EstablishmentMock.getOneEstablishment());
  }
}
