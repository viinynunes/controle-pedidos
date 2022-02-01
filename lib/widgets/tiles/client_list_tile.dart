import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/pages/client/client_registration_page.dart';
import 'package:flutter/material.dart';

class ClientListTile extends StatefulWidget {
  const ClientListTile({Key? key, required this.client}) : super(key: key);

  final ClientData client;

  @override
  _ClientListTileState createState() => _ClientListTileState();
}

class _ClientListTileState extends State<ClientListTile> {

  void _showClientRegistrationPage(ClientData? client) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClientRegistrationPage(
              client: client,
            )));
  }

  @override
  Widget build(BuildContext context) {
    ClientData client = widget.client;
    return InkWell(
      onTap: () {
        _showClientRegistrationPage(client);
      },
      child: Card(
          child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  client.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }


}
