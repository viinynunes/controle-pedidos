import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/export_files/stock_by_establishment_to_xlsx.dart';
import '../../../../../../core/reports/menu/modal_bottom_menu_export_options.dart';
import '../../../../../../core/reports/tables/android_custom_provider_data_table.dart';
import '../../../store/report_stock_by_establishment_controller.dart';

class AndroidReportStockByEstablishmentPage extends StatefulWidget {
  const AndroidReportStockByEstablishmentPage({Key? key}) : super(key: key);

  @override
  State<AndroidReportStockByEstablishmentPage> createState() =>
      _AndroidReportStockByEstablishmentPageState();
}

class _AndroidReportStockByEstablishmentPageState
    extends State<AndroidReportStockByEstablishmentPage> {
  final controller = GetIt.I.get<ReportStockByEstablishmentController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório por Estabelecimento'),
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
                    child: ElevatedButton(
                      onLongPress: controller.setDateRange,
                      onPressed: () async {
                        final result = await showDateRangePicker(
                            context: context,
                            initialDateRange: DateTimeRange(
                                start: controller.iniDate,
                                end: controller.endDate),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2200));

                        if (result != null) {
                          controller.setDateRange(
                              iniDate: result.start, endDate: result.end);
                        }
                      },
                      child: Observer(
                        builder: (context) {
                          return Text(controller.dateRange);
                        },
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
                                                  columnSpacing: 20,
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
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ModelBottomMenuExportOptions(
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
