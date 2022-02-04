import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/establishment_model.dart';
import 'package:controle_pedidos/pages/client/client_list_page.dart';
import 'package:controle_pedidos/pages/client/client_registration_page.dart';
import 'package:controle_pedidos/pages/establishment/establishmentList.dart';
import 'package:controle_pedidos/pages/establishment/establishment_registration_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  String? search;

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Pedidos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: Container(
            color: Colors.red,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Controle'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: Container(
            color: Colors.red,
          ),
        ),
        ScopedModelDescendant<EstablishmentModel>(
          builder: (context, child, model) => Scaffold(
              appBar: AppBar(
                title: const Text('CADASTROS'),
                centerTitle: true,
              ),
              drawer: CustomDrawer(
                pageController: _pageController,
              ),
              floatingActionButton: FloatingActionButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EstablishmentRegistrationPage()));
              }, child: const Icon(Icons.add),),
              body: const EstablishmentList()),
        ),
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
            drawer: CustomDrawer(
              pageController: _pageController,
            ),
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
