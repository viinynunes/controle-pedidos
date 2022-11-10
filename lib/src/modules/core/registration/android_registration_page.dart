import 'package:controle_pedidos/src/modules/product/presenter/pages/android/pages/android_product_list_page.dart';
import 'package:flutter/material.dart';

import '../../client/presenter/pages/android/android_client_list_page.dart';
import '../../establishment/presenter/pages/android/android_establishment_list_page.dart';
import '../../provider/presenter/pages/android/android_provider_list_page.dart';

class AndroidRegistrationsPage extends StatefulWidget {
  const AndroidRegistrationsPage({Key? key}) : super(key: key);

  @override
  State<AndroidRegistrationsPage> createState() =>
      _AndroidRegistrationsPageState();
}

class _AndroidRegistrationsPageState extends State<AndroidRegistrationsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastros'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: [
              _buildTile(
                  icon: Icons.production_quantity_limits,
                  text: 'Produto',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AndroidProductListPage()))),
              _buildTile(
                  icon: Icons.account_circle_outlined,
                  text: 'Clientes',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AndroidClientListPage()))),
              _buildTile(
                  icon: Icons.sports_handball_outlined,
                  text: 'Fornecedores',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AndroidProviderListPage()))),
              _buildTile(
                  icon: Icons.account_balance_sharp,
                  text: 'Estabelecimentos',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AndroidEstablishmentListPage()))),
            ],
          ),
        ),
      ),
    );
  }

  _buildTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Icon(icon)),
            Flexible(
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
