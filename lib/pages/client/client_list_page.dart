import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/client_list_tile.dart';
import 'package:flutter/material.dart';

import 'client_registration_page.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _getClientList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ClientRegistrationPage()));
          });
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _getClientList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                ClientData client =
                    ClientData.fromDocSnapshot(snapshot.data!.docs[index]);
                return ClientListTile(client: client);
              },
            );
          }
        },
      ),
    );
  }

  Future<QuerySnapshot> _getClientList() async {
    return await FirebaseFirestore.instance
        .collection('clients')
        .orderBy('name')
        .get();
  }
}
