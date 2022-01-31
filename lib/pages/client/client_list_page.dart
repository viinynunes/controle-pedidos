import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/widgets/tiles/client_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({
    Key? key,
  }) : super(key: key);

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ClientModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<ClientData>>(
          future: model.getAllClients(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ClientListTile(client: snapshot.data![index]);
                },
              );
            }
          },
        );
      },
    );
  }
}
