import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/services/client_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/tiles/client_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widgets/custom_drawer.dart';
import 'client_registration_page.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  final service = ClientService();
  List<ClientData> clientList = [];
  List<ClientData> secondaryClientList = [];

  @override
  void initState() {
    super.initState();

    _getClientList();
  }

  void _showClientRegistrationPage({ClientData? client}) async {
    final recClient = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClientRegistrationPage(
                  client: client,
                )));

    if (recClient != null) {
      if (client != null) {
        setState(() {
          ClientModel.of(context).updateClient(recClient);
          secondaryClientList.remove(client);
        });
      } else {
        ClientModel.of(context).createClient(recClient);
      }
      setState(() {
        secondaryClientList.add(recClient);
      });
    }

    setState(() {
      service.sortClientsByName(secondaryClientList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              hintText: 'Pesquisar',
              hintStyle: TextStyle(color: Colors.white)),
          style: const TextStyle(color: Colors.white, fontSize: 22),
          onChanged: (text) async {
            _filterClients(text);
          },
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showClientRegistrationPage();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: ListView.builder(
        itemCount: secondaryClientList.length,
        itemBuilder: (context, index) {
          var client = secondaryClientList[index];
          return Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: null,
              children: [
                SlidableAction(
                  onPressed: (e) {
                    setState(() {
                      ClientModel.of(context).disableClient(client);
                      secondaryClientList.remove(client);
                    });
                  },
                  icon: Icons.delete_forever,
                  label: 'Apagar',
                  backgroundColor: Colors.red,
                ),
                SlidableAction(
                  onPressed: (e) {
                    setState(() {
                      _showClientRegistrationPage(client: client);
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
      ),
    );
  }

  Future<void> _getClientList() async {
    final list = await ClientModel.of(context).getFilteredClients();

    setState(() {
      clientList = list;
      secondaryClientList.addAll(clientList);
    });
  }

  void _filterClients(String search) {
    List<ClientData> changeList = [];
    changeList.addAll(clientList);

    if (search.isNotEmpty) {
      List<ClientData> filteredList = [];
      for (var client in changeList) {
        if (client.name.toLowerCase().contains(search.toLowerCase())) {
          filteredList.add(client);
        }
      }

      setState(() {
        secondaryClientList.clear();
        secondaryClientList.addAll(filteredList);
      });
      return;
    } else {
      setState(() {
        secondaryClientList.clear();
        secondaryClientList.addAll(clientList);
      });
    }
  }
}
