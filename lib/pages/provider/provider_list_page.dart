import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/model/provider_model.dart';
import 'package:controle_pedidos/pages/provider/provider_registration_page.dart';
import 'package:controle_pedidos/services/provider_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/provider_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class ProviderListPage extends StatefulWidget {
  const ProviderListPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _ProviderListPageState createState() => _ProviderListPageState();
}

class _ProviderListPageState extends State<ProviderListPage> {
  final providerService = ProviderService();

  bool loading = false;
  bool isSearching = false;

  List<ProviderData> providerList = [];
  List<ProviderData> secondaryProviderList = [];

  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _updateProviderList();
  }

  void _showProviderRegistrationPage({ProviderData? provider}) async {
    final recProv = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProviderRegistrationPage(
                    provider: provider,
                  )));

    setState(() {
      loading = true;
    });

    if (recProv != null) {
      if (provider != null) {
        await ProviderModel.of(context).updateProvider(recProv);
        setState(() {
          secondaryProviderList.remove(provider);
          secondaryProviderList.add(recProv);
        });
      } else {
        setState(() {
          ProviderModel.of(context).createProvider(recProv);
          secondaryProviderList.add(recProv);
        });
      }
    }
    providerService.sortProviderListByName(secondaryProviderList);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProviderModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: isSearching
              ? TextField(
                  focusNode: _searchFocus,
                  decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      hintText: 'Pesquisar',
                      hintStyle: TextStyle(color: Colors.white)),
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  onChanged: (text) async {
                    _filterProviders(text);
                  },
                )
              : const Text('Fornecedores'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    _clearSearchFromSecondaryList();
                    isSearching = false;
                  } else {
                    isSearching = true;
                    _searchFocus.requestFocus();
                  }
                });
              },
              icon: isSearching
                  ? const Icon(Icons.cancel)
                  : const Icon(Icons.search),
            ),
          ],
        ),
        drawer: CustomDrawer(
          pageController: widget.pageController,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showProviderRegistrationPage();
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: CustomColors.backgroundColor,
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: secondaryProviderList.length,
                itemBuilder: (context, index) {
                  var provider = secondaryProviderList[index];
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
                                secondaryProviderList.remove(provider);
                              });
                            },
                            icon: Icons.delete_forever,
                            backgroundColor: Colors.red,
                            label: 'Apagar',
                          ),
                          SlidableAction(
                            onPressed: (e) {
                              setState(() {
                                _showProviderRegistrationPage(
                                    provider: provider);
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
              ),
      ),
    );
  }

  Future<void> _updateProviderList() async {
    setState(() {
      loading = true;
    });

    final list = await ProviderModel.of(context).getEnabledProviders();

    setState(() {
      providerList = list;
      secondaryProviderList.addAll(providerList);
      loading = false;
    });
  }

  void _filterProviders(String search) {
    List<ProviderData> changeList = [];
    changeList.addAll(providerList);

    if (search.isNotEmpty) {
      List<ProviderData> filteredList = [];
      for (var provider in changeList) {
        if (provider.name.toLowerCase().contains(search.toLowerCase())) {
          filteredList.add(provider);
        }
      }

      setState(() {
        secondaryProviderList.clear();
        secondaryProviderList.addAll(filteredList);
      });
      return;
    } else {
      _clearSearchFromSecondaryList();
    }
  }

  void _clearSearchFromSecondaryList() {
    setState(() {
      secondaryProviderList.clear();
      secondaryProviderList.addAll(providerList);
    });
  }
}
