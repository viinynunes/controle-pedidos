import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/widgets/tiles/client_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'client_registration_page.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({
    Key? key,
    this.search,
  }) : super(key: key);

  final String? search;

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  List<ClientData> clientList = [];

  @override
  void initState() {
    super.initState();

    _getClientList();
  }

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
    return ListView.builder(
      itemCount: clientList.length,
      itemBuilder: (context, index) {
        var client = clientList[index];
        return Slidable(
          key: const ValueKey(0),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: null,
            children: [
              SlidableAction(
                onPressed: (e) {
                  setState(() {});
                },
                icon: Icons.delete_forever,
                label: 'Apagar',
                backgroundColor: Colors.red,
              ),
              SlidableAction(
                onPressed: (e) {
                  setState(() {
                    _showClientRegistrationPage(client);
                  });
                },
                icon: Icons.edit,
                label: 'Editar',
                backgroundColor: Colors.deepPurple,
              )
            ],
          ),
          child: ClientListTile(client: client),
        );
      },
    );
  }

  Future<void> _getClientList() async {
    final list = await ClientModel.of(context).getFilteredClients();

    setState(() {
      clientList = list;
    });
  }
}
