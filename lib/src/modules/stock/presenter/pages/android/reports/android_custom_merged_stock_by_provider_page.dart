import 'package:flutter/material.dart';

import '../../../../../core/reports/menu/modal_bottom_menu_export_options.dart';
import '../../../../../core/widget_to_image/repaint_boundary_widget_key.dart';
import '../../../../../core/widget_to_image/transform_widget_to_image.dart';
import '../../../model/report_provider_model.dart';

class AndroidCustomMergedStockByProviderPage extends StatefulWidget {
  const AndroidCustomMergedStockByProviderPage(
      {Key? key, required this.providerList})
      : super(key: key);

  final List<ReportProviderModel> providerList;

  @override
  State<AndroidCustomMergedStockByProviderPage> createState() =>
      _AndroidCustomMergedStockByProviderPageState();
}

class _AndroidCustomMergedStockByProviderPageState
    extends State<AndroidCustomMergedStockByProviderPage> {
  late GlobalKey repaintKey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: RepaintBoundaryWidgetKey(
          builder: (key) {
            repaintKey = key;
            return Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.10, 10, size.width * 0.10, 10),
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.85,
                    child: ListView.builder(
                      itemCount: widget.providerList.length,
                      itemBuilder: (context, index) {
                        final provider = widget.providerList[index];
                        return Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    flex: 4,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      '${provider.providerName} - ${provider.providerLocation}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  const Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text('Emb',
                                          textAlign: TextAlign.center)),
                                  const Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        'Total',
                                        textAlign: TextAlign.center,
                                      )),
                                  const Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        'Sobra',
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.stockList.length,
                                itemBuilder: (_, index) {
                                  final stock = provider.stockList[index];

                                  return Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 0.1))),
                                    child: Row(
                                      children: [
                                        Flexible(
                                            flex: 4,
                                            fit: FlexFit.tight,
                                            child: Text(stock.product.name, maxLines: 1,)),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              stock.product.category,
                                              textAlign: TextAlign.center,
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              stock.totalOrdered.toString(),
                                              textAlign: TextAlign.center,
                                            )),
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            '${(stock.totalOrdered - stock.total)}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.7,
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ModelBottomMenuExportOptions(
                    onGenerateImage: () {
                      TransformWidgetToImage.transformAndLaunch(
                        repaintKey,
                        'TESTE',
                      );
                    },
                    onGenerateXLSX: () {},
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Exportar'.toUpperCase(),
                  ),
                  const Icon(Icons.share)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
