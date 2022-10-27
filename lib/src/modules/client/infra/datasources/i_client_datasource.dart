import '../models/client_model.dart';

abstract class IClientDatasource {
  Future<bool> createClient(ClientModel client);

  Future<bool> updateClient(ClientModel client);

  Future<bool> disableClient(ClientModel client);

  Future<ClientModel> getClientByID(String id);

  Future<List<ClientModel>> getClientList();
}
