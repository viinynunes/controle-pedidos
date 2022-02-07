import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/model/provider_model.dart';
import 'package:controle_pedidos/pages/provider/provider_registration_page.dart';
import 'package:controle_pedidos/widgets/tiles/provider_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class ProviderListPage extends StatefulWidget {
  const ProviderListPage({Key? key}) : super(key: key);

  @override
  _ProviderListPageState createState() => _ProviderListPageState();
}

class _ProviderListPageState extends State<ProviderListPage> {
  void _showProviderRegistrationPage({ProviderData? provider}) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => provider == null
                ? const ProviderRegistrationPage()
                : ProviderRegistrationPage(
                    provider: provider,
                  )));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProviderModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: const Text('Fornecedores'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showProviderRegistrationPage();
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<ProviderData>>(
          future: model.getEnabledProviders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var provider = snapshot.data![index];
                  return Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        dismissible: null,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (e) {
                              setState(() {
                                model.disableProvider(provider);
                              });
                            },
                            icon: Icons.delete_forever,
                            backgroundColor: Colors.red,
                            label: 'Apagar',
                          ),
                          SlidableAction(
                            onPressed: (e) {
                              setState(() {
                                _showProviderRegistrationPage(provider: provider);
                              });
                            },
                            icon: Icons.edit,
                            backgroundColor: Colors.deepPurple,
                            label: 'Editar',
                          ),
                        ],
                      ),
                      child: ProviderListTile(provider: provider));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
