import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';
import '../../../modules/order/presenter/pages/android/android_order_list_page.dart';
import '../../../modules/stock/presenter/pages/android/android_stock_page.dart';
import '../tiles/android_drawer_tile.dart';

class AndroidCustomDrawer extends StatefulWidget {
  const AndroidCustomDrawer({Key? key}) : super(key: key);

  @override
  _AndroidCustomDrawerState createState() => _AndroidCustomDrawerState();
}

class _AndroidCustomDrawerState extends State<AndroidCustomDrawer> {
  //final controller = GetIt.I.get<DrawerController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3,
      child: Stack(
        children: [
          Utils.buildBackground(),
          ListView(
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
                          const Expanded(
                            child: Text(
                              'Nunes',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Positioned(
                      child: Text(
                        'HFP',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      top: 60,
                    ),
                  ],
                ),
              ),
              const Divider(),
              AndroidDrawerTile(
                icon: Icons.storage,
                text: 'PEDIDOS',
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const AndroidOrderListPage()));
                },
              ),
              AndroidDrawerTile(
                icon: Icons.add_circle_sharp,
                text: 'CONTROLE',
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const AndroidStockPage()));
                },
              ),
              AndroidDrawerTile(
                icon: Icons.category,
                text: 'CADASTROS',
                onTap: () {
                  /*      Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const AndroidRegistrationNavigation()));*/
                },
              ),
              AndroidDrawerTile(
                icon: Icons.article,
                text: 'RELATÓRIOS',
                onTap: () {},
              ),
              /*DrawerTile(
                      icon: Icons.search,
                      text: 'TRANSAÇÕES',
                      pageController: pageController,
                      page: 4),*/
            ],
          ),
        ],
      ),
    );
  }
}
