import 'package:flutter/material.dart';

import '../../../../../../domain/models/stock_model.dart';
import '../../../../../core/export_files/stock_by_provider_to_xlsx.dart';
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
  List<StockModel> mergedList = [];

  @override
  void initState() {
    super.initState();

    for (var provider in widget.providerList) {
      if (provider.merge) {
        for (var stock in provider.stockList) {
          mergedList.add(StockModel.fromStock(stock));
        }
      }
    }

    widget.providerList.removeWhere((element) => element.merge == true);

    if (mergedList.isNotEmpty) {
      widget.providerList.add(ReportProviderModel(
          providerId: '0',
          providerName: 'Relatório Agrupado',
          providerLocation: '',
          stockList: mergedList,
          merge: true));
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.85,
                    child: ListView.builder(
                      itemCount: widget.providerList.length,
                      itemBuilder: (context, index) {
                        final provider = widget.providerList[index];
                        return DataTable(
                            horizontalMargin: 0,
                            columnSpacing: 0,
                            dataRowHeight: 20,
                            headingRowHeight: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)),
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: size.width * 0.4,
                                  child: provider.merge
                                      ? TextField(
                                          decoration: InputDecoration(
                                              hintText: 'Nomeie a tabela',
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        )
                                      : Text('${provider.providerName} - ${provider.providerLocation}'),
                                ),
                              ),
                              DataColumn(
                                  label: provider.merge
                                      ? ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth: size.width * 0.1),
                                          child: const Text('Local'))
                                      : Container()),
                              const DataColumn(label: Text('Emb')),
                              const DataColumn(label: Text('Total')),
                              const DataColumn(label: Text('Sobra')),
                            ],
                            rows: provider.stockList
                                .map(
                                  (stock) => DataRow(
                                    cells: [
                                      DataCell(Container(
                                        width: size.width * 0.4,
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(stock.product.name),
                                      )),
                                      DataCell(provider.merge
                                          ? Text(
                                              stock.product.provider!.location,
                                              textAlign: TextAlign.left,
                                            )
                                          : Container()),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(stock.product.category),
                                      )),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(stock.totalOrdered.toString()),
                                      )),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          '${(stock.totalOrdered - stock.total)}',
                                        ),
                                      )),
                                    ],
                                  ),
                                )
                                .toList());
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
                    onGenerateXLSX: () {
                      StockByProviderToXLSX().exportReportByProvider(
                          providerList: widget.providerList);
                    },
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
