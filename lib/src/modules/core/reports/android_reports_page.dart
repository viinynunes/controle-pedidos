import 'package:flutter/material.dart';

import '../helpers/custom_page_route.dart';

class AndroidReportsPage extends StatelessWidget {
  const AndroidReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _buildTile({
      required IconData icon,
      required String text,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Icon(icon),
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Relatório de Produtos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _buildTile(
                  icon: Icons.account_balance_sharp,
                  text: 'Produtos Por Estabelecimento',
                  onTap: () => Navigator.of(context).push(CustomPageRoute(
                      child: Container(), direction: AxisDirection.left))),
              _buildTile(
                  icon: Icons.sports_handball_outlined,
                  text: 'Produtos Por Fornecedor',
                  onTap: () => Navigator.of(context).push(CustomPageRoute(
                      child: Container(), direction: AxisDirection.left))),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Relatório de Pedidos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _buildTile(
                  icon: Icons.reorder,
                  text: 'Pedidos por Data',
                  onTap: () => Navigator.of(context).push(CustomPageRoute(
                      child: Container(), direction: AxisDirection.left))),
            ],
          ),
        ),
      ),
    );
  }
}
