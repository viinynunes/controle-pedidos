import 'package:controle_pedidos/pages/client/client_list_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
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
            color: Colors.blue,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: Container(
            color: Colors.orange,
          ),
        ),
        Scaffold(
            appBar: AppBar(
              title: const Text('Clientes'),
              centerTitle: true,
            ),
            drawer: CustomDrawer(
              pageController: _pageController,
            ),
            body: const ClientListPage()),
      ],
    );
  }
}
