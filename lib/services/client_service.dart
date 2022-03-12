import '../data/client_data.dart';

class ClientService {

  void sortClientsByName(List<ClientData> clientList){
    clientList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}