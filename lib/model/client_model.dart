import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/client_data.dart';
import 'package:scoped_model/scoped_model.dart';

class ClientModel extends Model {
  bool isLoading = false;

  void createClient(ClientData client){
    FirebaseFirestore.instance.collection('clients').doc().set(client.toMap());
  }

  void updateClient(ClientData client){
    FirebaseFirestore.instance.collection('clients').doc(client.id).update(client.toMap());
  }

  void disableClient(ClientData client){
    client.enabled = false;
    FirebaseFirestore.instance.collection('clients').doc(client.id).update(client.toMap());
  }

  Future<ClientData> getOneClient(String id){
    return FirebaseFirestore.instance.collection('clients').doc(id).get().then((value) => ClientData.fromDocSnapshot(value));
  }

  Future<List<ClientData>> getEnabledClients() async {
    isLoading = true;
    List<ClientData> clientList = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('clients').where('enabled').get();
    for (DocumentSnapshot e in snapshot.docs) {
      if(e.get('enabled')){
        clientList.add(ClientData.fromDocSnapshot(e));
      }
    }
    isLoading = false;
    notifyListeners();
    return clientList;
  }
}
