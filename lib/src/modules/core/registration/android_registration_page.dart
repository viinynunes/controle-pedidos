import 'package:controle_pedidos/src/modules/product/presenter/pages/android/pages/android_product_list_page.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/android/pages/android_provider_list_page.dart';
import 'package:flutter/material.dart';

import '../../client/presenter/pages/android/android_client_list_page.dart';
import '../../establishment/presenter/android/pages/android_establishment_list_page.dart';

class AndroidRegistrationNavigation extends StatefulWidget {
  const AndroidRegistrationNavigation({Key? key}) : super(key: key);

  @override
  State<AndroidRegistrationNavigation> createState() =>
      _AndroidRegistrationNavigationState();
}

class _AndroidRegistrationNavigationState
    extends State<AndroidRegistrationNavigation> {
  int _registrationPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _registrationPageElements = [
      const AndroidProductListPage(),
      const AndroidClientListPage(),
      const AndroidProviderListPage(),
      const AndroidEstablishmentListPage(),
    ];

    return Scaffold(
      body: _registrationPageElements.elementAt(_registrationPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        currentIndex: _registrationPageIndex,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.production_quantity_limits,
              ),
              label: 'Produtos'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
              ),
              label: 'Clientes'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.sports_handball_outlined,
              ),
              label: 'Fornecedores'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_sharp,
              ),
              label: 'Estabelecimentos'),
        ],
        onTap: (index) {
          setState(() {
            _registrationPageIndex = index;
          });
        },
      ),
    );
  }
}
