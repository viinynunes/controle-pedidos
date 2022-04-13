import 'package:controle_pedidos/pages/control/control_stock_management.dart';
import 'package:flutter/material.dart';

class ControlHomePage extends StatefulWidget {
  const ControlHomePage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _ControlHomePageState createState() => _ControlHomePageState();
}

class _ControlHomePageState extends State<ControlHomePage> {
  final pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageViewController,
      physics: const BouncingScrollPhysics(),
      children: [
        ControlStockManagement(pageController: widget.pageController),
        ControlStockManagement(pageController: widget.pageController),
      ],
    );
  }
}
