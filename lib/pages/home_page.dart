import 'package:controle_pedidos/pages/control/control_home_page.dart';
import 'package:controle_pedidos/pages/order/order_list_page.dart';
import 'package:controle_pedidos/pages/registration/registration_home_page.dart';
import 'package:controle_pedidos/pages/reports/report_home.dart';
import 'package:controle_pedidos/pages/transactions/transactions_page.dart';
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
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        OrderListPage(
          pageController: _pageController,
        ),
        ControlHomePage(pageController: _pageController),
        RegistrationHomePage(pageController: _pageController),
        ReportHomePage(
          pageController: _pageController,
        ),
        TransactionsPage(
          pageController: _pageController,
        ),
      ],
    );
  }
}
