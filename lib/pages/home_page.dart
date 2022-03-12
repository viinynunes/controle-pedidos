import 'package:controle_pedidos/pages/client/client_list_page.dart';
import 'package:controle_pedidos/pages/control/control_home_page.dart';
import 'package:controle_pedidos/pages/establishment/establishment_list_page.dart';
import 'package:controle_pedidos/pages/order/order_list_page.dart';
import 'package:controle_pedidos/pages/product/product_list_page.dart';
import 'package:controle_pedidos/pages/provider/provider_list_page.dart';
import 'package:controle_pedidos/pages/reports/report_home.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? search;
  int _registrationPageIndex = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _registrationPageElements = <Widget>[
      ProductListPage(
        pageController: _pageController,
      ),
      ProviderListPage(
        pageController: _pageController,
      ),
      EstablishmentListPage(
        pageController: _pageController,
      ),
    ];

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        OrderListPage(
          pageController: _pageController,
        ),
        ControlHomePage(pageController: _pageController),
        Scaffold(
            body: _registrationPageElements.elementAt(_registrationPageIndex),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: CustomColors.bottomNavigationBarColor,
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: CustomColors.textColorTile,
              currentIndex: _registrationPageIndex,
              elevation: 10,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.production_quantity_limits,
                      color: CustomColors.textColorTile,
                    ),
                    label: 'Produtos'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.sports_handball_outlined,
                      color: CustomColors.textColorTile,
                    ),
                    label: 'Fornecedores'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_balance_sharp,
                      color: CustomColors.textColorTile,
                    ),
                    label: 'Estabelecimentos'),
              ],
              onTap: (index) {
                setState(() {
                  _registrationPageIndex = index;
                });
              },
            )),
        ClientListPage(
          pageController: _pageController,
        ),
        ReportHomePage(
          pageController: _pageController,
        ),
      ],
    );
  }
}
