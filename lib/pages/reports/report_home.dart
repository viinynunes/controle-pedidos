import 'package:controle_pedidos/pages/reports/orders/report_orders_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ReportHomePage extends StatelessWidget {
  const ReportHomePage({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o relatório'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(pageController: pageController,),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportOrdersPage()));
                    }, child: const Text('Pedidos')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Produtos')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
