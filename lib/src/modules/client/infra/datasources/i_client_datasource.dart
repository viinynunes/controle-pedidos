import '../../../../domain/models/client_model.dart';

abstract class IClientDatasource {
  Future<ClientModel> createClient(ClientModel client);

  Future<ClientModel> updateClient(ClientModel client);

  Future<bool> disableClient(ClientModel client);

  Future<ClientModel> getClientByID(String id);

  Future<List<ClientModel>> getClientListByEnabled();

  Future<List<ClientModel>> getClientList();
}
