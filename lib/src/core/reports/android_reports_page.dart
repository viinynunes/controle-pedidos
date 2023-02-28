import 'package:auto_size_text/auto_size_text.dart';
import 'package:controle_pedidos/src/core/admob/services/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../modules/order/presenter/pages/android/reports/android_order_report_page.dart';
import '../../modules/stock/presenter/pages/android/reports/android_report_stock_by_establishment_page.dart';
import '../../modules/stock/presenter/pages/android/reports/android_report_stock_by_provider_page.dart';
import '../admob/widgest/banner_ad_widget.dart';
import '../helpers/custom_page_route.dart';

class AndroidReportsPage extends StatelessWidget {
  const AndroidReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(icon),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      text,
                      maxLines: 1,
                      minFontSize: 5,
                    ),
                  ),
                ],
              ),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: AutoSizeText(
                    'Relatório de Produtos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _buildTile(
                    icon: Icons.account_balance_sharp,
                    text: 'Produtos Por Estabelecimento',
                    onTap: () => Navigator.of(context).push(CustomPageRoute(
                        child: const AndroidReportStockByEstablishmentPage(),
                        direction: AxisDirection.left))),
                _buildTile(
                    icon: Icons.sports_handball_outlined,
                    text: 'Produtos Por Fornecedor',
                    onTap: () => Navigator.of(context).push(CustomPageRoute(
                        child: const AndroidReportStockByProviderPage(),
                        direction: AxisDirection.left))),
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
                        child: const AndroidOrderReportPage(),
                        direction: AxisDirection.left))),

                BannerAdWidget(
                  showAd: GetIt.I.get<AdService>().showBannerAd(),
                  width: size.width,
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
