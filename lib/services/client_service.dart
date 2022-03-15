import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/pages/client/client_registration_page.dart';
import 'package:flutter/material.dart';

import '../data/client_data.dart';

class ClientService {
  Future<ClientData?> createOrUpdate(
      {ClientData? client,
      required List<ClientData> clientList,
      required BuildContext context}) async {
    final recClient = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientRegistrationPage(
          client: client,
        ),
      ),
    );

    if (recClient != null) {
      if (client != null) {
        ClientModel.of(context).updateClient(recClient);
        clientList.remove(client);
      } else {
        ClientModel.of(context).createClient(recClient);
      }
      clientList.add(recClient);
    }

    return recClient;
  }

  void sortClientsByName(List<ClientData> clientList) {
    clientList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
