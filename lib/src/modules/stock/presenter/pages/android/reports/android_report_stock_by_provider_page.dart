import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/reports/menu/modal_bottom_menu_export_options.dart';
import '../../../store/report_stock_by_provider_controller.dart';

class AndroidReportStockByProviderPage extends StatefulWidget {
  const AndroidReportStockByProviderPage({Key? key}) : super(key: key);

  @override
  State<AndroidReportStockByProviderPage> createState() =>
      _AndroidReportStockByProviderPageState();
}

class _AndroidReportStockByProviderPageState
    extends State<AndroidReportStockByProviderPage> {
  final controller = GetIt.I.get<ReportStockByProviderController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório por Fornecedor'),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => controller.selectedProviderModelList.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        controller.selectedProviderModelList.length.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.arrow_right_alt),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) => ModelBottomMenuExportOptions(
                    onGenerateXLSX: () {},
                  ));
        },
        label: const Text('Gerar'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onLongPress: controller.resetDateRange,
                      onPressed: () async {
                        final result = await showDateRangePicker(
                            context: context,
                            initialDateRange: DateTimeRange(
                                start: controller.iniDate,
                                end: controller.endDate),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2200));

                        if (result != null) {
                          controller.setDateRange(result.start, result.end);
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
                  Observer(builder: (context) {
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
                        children: controller.providerModelList
                            .map(
                              (provider) => ExpansionPanelRadio(
                                value: UniqueKey(),
                                canTapOnHeader: true,
                                headerBuilder: (_, isOpen) {
                                  return Observer(builder: (context) {
                                    return GestureDetector(
                                      onLongPress: () {
                                        controller.selectedProviderModelList
                                                .contains(provider)
                                            ? controller
                                                .removeReportProviderModel(
                                                    provider)
                                            : controller
                                                .addSelectedReportProviderModel(
                                                    provider);
                                      },
                                      child: Card(
                                        color: controller
                                                .selectedProviderModelList
                                                .contains(provider)
                                            ? Theme.of(context)
                                                .backgroundColor
                                                .withOpacity(0.7)
                                            : Theme.of(context).cardColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                provider.providerName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            controller.selectedProviderModelList
                                                    .contains(provider)
                                                ? Switch(
                                                    value: provider.merge,
                                                    activeColor: Theme.of(context).scaffoldBackgroundColor,
                                                    onChanged: (_) {
                                                      setState(() {
                                                        controller.toggleMerge(
                                                            provider);
                                                      });
                                                    })
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                                body: DataTable(
                                  columnSpacing: 10,
                                  columns: const [
                                    DataColumn(label: Text('Produto')),
                                    DataColumn(label: Text('Emb')),
                                    DataColumn(label: Text('Pedido')),
                                    DataColumn(label: Text('Total')),
                                    DataColumn(label: Text('Sobra')),
                                  ],
                                  rows: provider.stockList
                                      .map(
                                        (stock) => DataRow(
                                          cells: [
                                            DataCell(Text(stock.product.name)),
                                            DataCell(
                                                Text(stock.product.category)),
                                            DataCell(
                                                Text(stock.total.toString())),
                                            DataCell(Text(
                                                stock.totalOrdered.toString())),
                                            DataCell(Text(
                                                '${(stock.totalOrdered - stock.total)}')),
                                          ],
                                        ),
                                      )
                                      .toList(),
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
    );
  }
}
