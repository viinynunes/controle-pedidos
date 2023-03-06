import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/export_files/stock_by_provider_to_xlsx.dart';
import '../../../../../../core/reports/menu/modal_bottom_menu_export_options.dart';
import '../../../../../../core/reports/tables/android_custom_provider_data_table.dart';
import '../../../../../../core/ui/states/base_state.dart';
import '../../../../../../core/ui/user_tips/tips_controller.dart';
import '../../../../../../core/ui/user_tips/report_tutorial_dialog.dart';
import '../../../../../../core/widget_to_image/repaint_boundary_widget_key.dart';
import '../../../../../../core/widget_to_image/transform_widget_to_image.dart';
import '../../../../../../domain/entities/establishment.dart';
import '../../../../../../domain/entities/provider.dart';
import '../../../../../../domain/models/report_provider_model.dart';
import '../../../../../../domain/models/stock_model.dart';

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
    extends BaseState<AndroidCustomMergedStockByProviderPage, TipsController> {
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
          provider: Provider(
              id: '0',
              name: 'Relatório Agrupado',
              location: '',
              enabled: true,
              registrationDate: DateTime.now(),
              establishment: Establishment(
                  id: '',
                  name: '',
                  registrationDate: DateTime.now(),
                  enabled: true)),
          stockList: mergedList,
          merge: true));
    }
  }

  @override
  onReady() {
    if (controller.showStockReportByProviderTip()) {
      showTutorialDialog();
    }
  }

  showTutorialDialog() async {
    await showDialog(
      context: context,
      builder: (_) => TipsDialog(
        message:
            'Para visualizar o relatório em XLSX, é necessário ter instalado algum aplicativo visualizador de xlsx, como o Excel ou o Sheets',
        onDontShowAgain: controller.disableStockReportByProviderTip,
      ),
    );
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
                            columnSpacing:
                                MediaQuery.of(context).size.width * .01,
                            providerModel: provider,
                            withMergeOptions: true,
                            blackFontColor: true,
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
                  builder: (_) => ModalBottomMenuExportOptions(
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
