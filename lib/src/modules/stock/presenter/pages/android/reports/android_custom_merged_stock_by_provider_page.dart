import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../domain/models/stock_model.dart';
import '../../../../../core/export_files/stock_by_provider_to_xlsx.dart';
import '../../../../../core/reports/menu/modal_bottom_menu_export_options.dart';
import '../../../../../core/widget_to_image/repaint_boundary_widget_key.dart';
import '../../../../../core/widget_to_image/transform_widget_to_image.dart';
import '../../../../../../domain/models/report_provider_model.dart';
import '../../../../../core/reports/tables/android_custom_provider_data_table.dart';

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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: AndroidCustomProviderDataTable(
                            provider: provider,
                            withMergeOptions: true,
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
                        'Custom Report By Provider ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
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
