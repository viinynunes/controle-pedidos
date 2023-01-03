import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/helpers/custom_page_route.dart';
import '../../../../../../core/reports/tables/android_custom_provider_data_table.dart';
import '../../../store/report_stock_by_provider_controller.dart';
import 'android_custom_merged_stock_by_provider_page.dart';

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
        title: Observer(
          builder: (_) => controller.selecting
              ? Container()
              : const Text('Customize o Relatório'),
        ),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => controller.selectedProviderModelList.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        controller.selectedProviderModelList.length.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  )
                : Container(),
          ),
          Observer(
              builder: (_) => controller.selecting
                  ? Row(
                      children: [
                        Switch(
                            value: controller.mergeAllSelected,
                            onChanged: (merge) {
                              controller.toggleMergeAllSelectedProviders(merge);
                              setState(() {});
                            }),
                        IconButton(
                            onPressed:
                                controller.clearSelectedReportProviderModelList,
                            icon: const Icon(Icons.clear))
                      ],
                    )
                  : Container()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.arrow_right_alt),
        onPressed: () {
          Navigator.of(context)
              .push(CustomPageRoute(
                  child: AndroidCustomMergedStockByProviderPage(
                    providerList: controller.getProviderListToShare(),
                  ),
                  direction: AxisDirection.left))
              .then((value) {
            controller.getStockListBetweenDates();
            controller.clearSelectedReportProviderModelList();
          });
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
                              (providerModel) => ExpansionPanelRadio(
                                value: UniqueKey(),
                                canTapOnHeader: true,
                                headerBuilder: (_, isOpen) {
                                  return Observer(builder: (context) {
                                    return GestureDetector(
                                      onTap: controller.selecting
                                          ? () => controller
                                              .addRemoveSelectedReportProviderModel(
                                                  providerModel)
                                          : null,
                                      onLongPress: () {
                                        controller
                                            .addRemoveSelectedReportProviderModel(
                                                providerModel);
                                      },
                                      child: Card(
                                        color: controller
                                                .selectedProviderModelList
                                                .contains(providerModel)
                                            ? Theme.of(context)
                                                .indicatorColor
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
                                                '${providerModel.provider.name} - ${providerModel.provider.location}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            controller.selectedProviderModelList
                                                    .contains(providerModel)
                                                ? Switch(
                                                    value: providerModel.merge,
                                                    activeColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    onChanged: (_) {
                                                      setState(() {
                                                        controller.toggleMerge(
                                                            providerModel);
                                                      });
                                                    })
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                                body: AndroidCustomProviderDataTable(
                                  providerModel: providerModel,
                                  columnSpacing: 20,
                                  withMergeOptions: false,
                                  blackFontColor:
                                      Theme.of(context).brightness ==
                                          Brightness.light,
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
