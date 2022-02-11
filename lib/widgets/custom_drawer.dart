import 'package:controle_pedidos/model/user_model.dart';
import 'package:controle_pedidos/pages/login_page.dart';
import 'package:controle_pedidos/utils/utils.dart';
import 'package:controle_pedidos/widgets/tiles/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final pageController = widget.pageController;

    return Drawer(
      elevation: 3,
      child: Stack(
        children: [
          Utils.buildBackground(),
          ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              return ListView(
                padding: const EdgeInsets.only(left: 32, top: 16),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8, top: 50),
                    padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                    height: 170,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  model.userData['name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    model.signOut(
                                        onLogout: () =>
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage())));
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Positioned(
                          child: Text(
                            model.userData['company'] ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          top: 60,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  DrawerTile(
                    icon: Icons.storage,
                    text: 'PEDIDOS',
                    pageController: pageController,
                    page: 0,
                  ),
                  DrawerTile(
                    icon: Icons.add_circle_sharp,
                    text: 'CONTROLE',
                    pageController: pageController,
                    page: 1,
                  ),
                  DrawerTile(
                    icon: Icons.category,
                    text: 'CADASTROS',
                    pageController: pageController,
                    page: 2,
                  ),
                  DrawerTile(
                    icon: Icons.account_circle_outlined,
                    text: 'CLIENTES',
                    pageController: pageController,
                    page: 3,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
