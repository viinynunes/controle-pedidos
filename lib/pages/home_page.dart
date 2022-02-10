import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/drawer_page_controller.dart';
import 'package:controle_pedidos/pages/client/client_list_page.dart';
import 'package:controle_pedidos/pages/client/client_registration_page.dart';
import 'package:controle_pedidos/pages/establishment/establishment_list_page.dart';
import 'package:controle_pedidos/pages/order/order_list_page.dart';
import 'package:controle_pedidos/pages/product/product_list_page.dart';
import 'package:controle_pedidos/pages/provider/provider_list_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? search;
  int _registrationPageIndex = 0;

  final List<Widget> _registrationPageElements = <Widget>[
    const ProductListPage(),
    const ProviderListPage(),
    const EstablishmentListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final _pageController = DrawerPageController.of(context).pageController;

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        const OrderListPage(),
        Scaffold(
          appBar: AppBar(
            title: const Text('Controle'),
            centerTitle: true,
          ),
          drawer: const CustomDrawer(),
          body: Container(
            color: Colors.red,
          ),
        ),
        Scaffold(
            drawer: const CustomDrawer(),
            body: _registrationPageElements.elementAt(_registrationPageIndex),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.production_quantity_limits),
                    label: 'Produtos'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.sports_handball_outlined),
                    label: 'Fornecedores'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_sharp),
                    label: 'Estabelecimentos'),
              ],
              currentIndex: _registrationPageIndex,
              selectedItemColor: Colors.deepPurple,
              onTap: (index) {
                setState(() {
                  _registrationPageIndex = index;
                });
              },
            )),
        ScopedModelDescendant<ClientModel>(
          builder: (context, child, model) => Scaffold(
            appBar: AppBar(
              title: TextField(
                decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    hintText: 'Pesquisar',
                    hintStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white, fontSize: 22),
                onChanged: (text) async {
                  await model.getFilteredClients(search: text);
                  if (text.isEmpty) {
                    search = null;
                  } else {
                    search = text;
                  }
                },
              ),
              centerTitle: true,
            ),
            drawer: const CustomDrawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ClientRegistrationPage()));
                });
              },
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
            body: ClientListPage(
              search: search,
            ),
          ),
        ),
      ],
    );
  }
}
