import 'package:controle_pedidos/src/domain/models/client_model.dart';

class ClientMock {
  static ClientModel getOneClient(
      {String id = 'clientID01',
      String name = 'Client Name 01',
      String phone = '40020922',
      String email = 'client@gmail.com',
      String address = 'Soares Avenue',
      bool enabled = true}) {
    return ClientModel(
        id: id,
        name: name,
        phone: phone,
        email: email,
        address: address,
        enabled: enabled);
  }
}
