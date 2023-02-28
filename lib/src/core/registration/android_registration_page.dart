import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../modules/client/presenter/pages/android/android_client_list_page.dart';
import '../../modules/establishment/presenter/pages/android/android_establishment_list_page.dart';
import '../../modules/product/presenter/pages/android/pages/android_product_list_page.dart';
import '../../modules/provider/presenter/pages/android/android_provider_list_page.dart';
import '../admob/services/ad_service.dart';
import '../admob/widgest/banner_ad_widget.dart';
import '../helpers/custom_page_route.dart';

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
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BannerAdWidget(
                  showAd: GetIt.I.get<AdService>().showBannerAd(),
                  height: size.height * 0.1,
                  width: size.width,
                ),
                _buildTile(
                    icon: Icons.production_quantity_limits,
                    text: 'Produto',
                    onTap: () => Navigator.of(context).push(CustomPageRoute(
                        child: const AndroidProductListPage(),
                        direction: AxisDirection.left))),

                _buildTile(
                    icon: Icons.account_circle_outlined,
                    text: 'Clientes',
                    onTap: () => Navigator.of(context).push(CustomPageRoute(
                        child: const AndroidClientListPage(),
                        direction: AxisDirection.left))),

                _buildTile(
                    icon: Icons.sports_handball_outlined,
                    text: 'Fornecedores',
                    onTap: () => Navigator.of(context).push(CustomPageRoute(
                        child: const AndroidProviderListPage(),
                        direction: AxisDirection.left))),

                _buildTile(
                    icon: Icons.account_balance_sharp,
                    text: 'Estabelecimentos',
                    onTap: () => Navigator.of(context).push(CustomPageRoute(
                        child: const AndroidEstablishmentListPage(),
                        direction: AxisDirection.left))),
                BannerAdWidget(
                  showAd: GetIt.I.get<AdService>().showBannerAd(),
                  height: size.height * 0.1,
                  width: size.width,
                ),
              ],
            ),
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
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
