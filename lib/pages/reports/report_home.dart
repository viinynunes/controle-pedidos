import 'package:controle_pedidos/pages/reports/orders/report_orders_page.dart';
import 'package:controle_pedidos/pages/reports/providers/report_providers_page.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ReportHomePage extends StatelessWidget {
  const ReportHomePage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {

    final desktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o relatório'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        pageController: pageController,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: desktop ? 1080 : double.maxFinite
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportOrdersPage()));
                      },
                      child: const Text('Pedidos')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ReportProvidersPage()));
                      },
                      child: const Text('Fornecedores')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
