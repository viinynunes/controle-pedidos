import 'package:auto_size_text/auto_size_text.dart';
import 'package:controle_pedidos/src/core/admob/admob_helper.dart';
import 'package:controle_pedidos/src/core/admob/services/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/admob/widgest/banner_ad_widget.dart';
import '../../../../../core/widget_to_image/repaint_boundary_widget_key.dart';
import '../../../../../core/widget_to_image/transform_widget_to_image.dart';
import '../../../../../domain/entities/stock.dart';

class AndroidShareStockListByProviderPage extends StatefulWidget {
  const AndroidShareStockListByProviderPage(
      {Key? key, required this.providerName, required this.stockList})
      : super(key: key);

  final String providerName;
  final List<Stock> stockList;

  @override
  State<AndroidShareStockListByProviderPage> createState() =>
      _AndroidShareStockListByProviderPageState();
}

class _AndroidShareStockListByProviderPageState
    extends State<AndroidShareStockListByProviderPage> {
  late GlobalKey repaintKey;

  final adHelper = AdMobHelper();

  @override
  void initState() {
    super.initState();

    adHelper.createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Exportar Fornecedor',
          maxLines: 1,
          minFontSize: 5,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await TransformWidgetToImage.transformAndLaunch(
                    repaintKey, widget.providerName);
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          adHelper.showRewardedAd();
          return true;
        },
        child: RepaintBoundaryWidgetKey(
          builder: (key) {
            repaintKey = key;
            return Center(
              child: Container(
                color: Colors.white,
                //padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
                padding: EdgeInsets.fromLTRB(
                    size.width * 0.15, 0, size.width * 0.15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.providerName,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.stockList.length,
                        itemBuilder: (context, index) {
                          final item = widget.stockList[index];
                          return Container(
                            width: size.width,
                            padding: const EdgeInsets.only(top: 1, bottom: 1),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.5))),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 1, 2, 1),
                                  child: Text(
                                    item.totalOrdered.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 1, 2, 1),
                                  child: Text(
                                    item.product.category,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                Text(
                                  item.product.name,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    BannerAdWidget(
                      showAd: GetIt.I.get<AdService>().loadAd(),
                      height: size.height * 0.1,
                      width: size.width,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
