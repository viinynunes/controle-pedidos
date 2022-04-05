import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/services/client_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/tiles/client_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widgets/custom_drawer.dart';

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

  bool loading = false;

  @override
  void initState() {
    super.initState();

    _getClientList();
  }

  void _showClientRegistrationPage({ClientData? client}) async {
    setState(() {
      loading = true;
    });
    await service.createOrUpdate(
        client: client, clientList: clientList, context: context);

    setState(() {
      _getClientList();
      service.sortClientsByName(secondaryClientList);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final desktop = MediaQuery.of(context).size.width > 600;

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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: desktop ? 1080 : double.maxFinite
          ),
          child: ListView.builder(
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
        ),
      ),
    );
  }

  Future<void> _getClientList() async {
    if (mounted){
      final list = await ClientModel.of(context).getFilteredClients();

      setState(() {
        clientList = list;
        secondaryClientList.clear();
        secondaryClientList.addAll(clientList);
      });
    }

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
