import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/widgets/tiles/client_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'client_registration_page.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({
    Key? key,
  }) : super(key: key);

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
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
    return ScopedModelDescendant<ClientModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<ClientData>>(
          future: model.getEnabledClients(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: null,
                        children: [
                          SlidableAction(
                            onPressed: (e) {
                              setState(() {
                                model.disableClient(snapshot.data![index]);
                              });
                            },
                            icon: Icons.delete_forever,
                            label: 'Apagar',
                            backgroundColor: Colors.red,
                          ),
                          SlidableAction(
                            onPressed: (e) {
                              setState(() {
                                _showClientRegistrationPage(item);
                              });
                            },
                            icon: Icons.edit,
                            label: 'Editar',
                            backgroundColor: Colors.deepPurple,
                          )
                        ],
                      ),
                      child: ClientListTile(client: item));
                },
              );
            }
          },
        );
      },
    );

  }

}
