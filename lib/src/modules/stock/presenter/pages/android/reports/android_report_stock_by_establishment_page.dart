import 'package:auto_size_text/auto_size_text.dart';
import 'package:controle_pedidos/src/core/admob/admob_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/export_files/stock_by_establishment_to_xlsx.dart';
import '../../../../../../core/reports/menu/modal_bottom_menu_export_options.dart';
import '../../../../../../core/reports/tables/android_custom_provider_data_table.dart';
import '../../../../../../core/ui/states/base_state.dart';
import '../../../../../../core/ui/user_tips/tipsController.dart';
import '../../../../../../core/ui/user_tips/report_tutorial_dialog.dart';
import '../../../../../../core/widgets/custom_date_range_picker_widget.dart';
import '../../../store/report_stock_by_establishment_controller.dart';

class AndroidReportStockByEstablishmentPage extends StatefulWidget {
  const AndroidReportStockByEstablishmentPage({Key? key}) : super(key: key);

  @override
  State<AndroidReportStockByEstablishmentPage> createState() =>
      _AndroidReportStockByEstablishmentPageState();
}

class _AndroidReportStockByEstablishmentPageState extends BaseState<
    AndroidReportStockByEstablishmentPage,
    ReportStockByEstablishmentController> {
  final tipController = GetIt.I.get<TipsController>();
  final adHelper = AdMobHelper();

  @override
  void initState() {
    super.initState();

    adHelper.createRewardedAd();
    controller.initState();
  }

  @override
  onReady() {
    if (tipController.showStockReportByEstablishmentTip()) {
      showTutorialDialog();
    }
  }

  showTutorialDialog() async {
    await showDialog(
      context: context,
      builder: (_) => TipsDialog(
        message:
            'Para visualizar o relatório, é necessário ter instalado algum aplicativo visualizador de xlsx, como o Excel ou o Sheets',
        onDontShowAgain: tipController.disableStockReportByEstablishmentTip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Relatório por Estabelecimento',
          minFontSize: 5,
          maxLines: 1,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Observer(
                      builder: (context) => CustomDateRangePickerWidget(
                        iniDate: controller.iniDate,
                        endDate: controller.endDate,
                        afterSelect: (DateTime iniDate, DateTime endDate) {
                          controller.setDateRange(
                              iniDate: iniDate, endDate: endDate);
                        },
                        onLongPress: controller.setDateRange,
                        text: controller.dateRange,
                      ),
                    ),
                  ),
                  const Divider(),
                  Observer(builder: (_) {
                    if (controller.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: ExpansionPanelList.radio(
                        expandedHeaderPadding: const EdgeInsets.all(8),
                        elevation: 0,
                        children: controller.establishmentList
                            .map(
                              (establishmentModel) => ExpansionPanelRadio(
                                value: UniqueKey(),
                                canTapOnHeader: true,
                                headerBuilder: (_, isOpen) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        establishmentModel.establishment.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  );
                                },
                                body: SingleChildScrollView(
                                  child: Column(
                                    children: establishmentModel.providerList
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${e.provider.name} - ${e.provider.location}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                AndroidCustomProviderDataTable(
                                                  providerModel: e,
                                                  columnSpacing:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .02,
                                                  withMergeOptions: false,
                                                  blackFontColor:
                                                      Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                if (controller.showBannerAd()) {
                  adHelper.showRewardedAd();
                }

                showModalBottomSheet(
                  context: context,
                  builder: (_) => ModalBottomMenuExportOptions(
                    onGenerateXLSX: () {
                      StockByEstablishmentToXLSX().exportReportByEstablishment(
                          establishmentList: controller.establishmentList);
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
