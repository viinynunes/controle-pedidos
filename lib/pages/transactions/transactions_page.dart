import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), drawer: CustomDrawer(pageController: widget.pageController,),);
  }
}
