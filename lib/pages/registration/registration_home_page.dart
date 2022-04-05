import 'package:flutter/material.dart';

import '../../utils/custom_colors.dart';
import '../client/client_list_page.dart';
import '../establishment/establishment_list_page.dart';
import '../product/product_list_page.dart';
import '../provider/provider_list_page.dart';

class RegistrationHomePage extends StatefulWidget {
  const RegistrationHomePage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<RegistrationHomePage> createState() => _RegistrationHomePageState();
}

class _RegistrationHomePageState extends State<RegistrationHomePage> {
  int _registrationPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _registrationPageElements = [
      ProductListPage(
        pageController: widget.pageController,
      ),
      ClientListPage(
        pageController: widget.pageController,
      ),
      ProviderListPage(
        pageController: widget.pageController,
      ),
      EstablishmentListPage(
        pageController: widget.pageController,
      ),
    ];

    return Scaffold(
      body: _registrationPageElements.elementAt(_registrationPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        type: BottomNavigationBarType.fixed,
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
                Icons.account_circle_outlined,
                color: CustomColors.textColorTile,
              ),
              label: 'Clientes'),
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
      ),
    );
  }
}
