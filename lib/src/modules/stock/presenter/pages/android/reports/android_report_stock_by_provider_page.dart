import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/admob/admob_helper.dart';
import '../../../../../../core/helpers/custom_page_route.dart';
import '../../../../../../core/reports/tables/android_custom_provider_data_table.dart';
import '../../../../../../core/widgets/custom_date_range_picker_widget.dart';
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
  final adHelper = AdMobHelper();


  @override
  void initState() {
    super.initState();

    adHelper.createRewardedAd();
    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => controller.selecting
              ? Container()
              : const AutoSizeText(
                  'Customize o Relatório',
                  minFontSize: 5,
                  maxLines: 1,
                ),
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

          if(controller.showAds()){
            adHelper.showRewardedAd();
          }

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
                    child: Observer(
                      builder: (context) => CustomDateRangePickerWidget(
                        iniDate: controller.iniDate,
                        endDate: controller.endDate,
                        afterSelect: (DateTime iniDate, DateTime endDate) {
                          controller.setDateRange(iniDate, endDate);
                        },
                        onLongPress: controller.resetDateRange,
                        text: controller.dateRange,
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
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  '${providerModel.provider.name} - ${providerModel.provider.location}',
                                                  maxLines: 1,
                                                  minFontSize: 5,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Visibility(
                                                visible: controller
                                                    .selectedProviderModelList
                                                    .contains(providerModel),
                                                child: Switch(
                                                    value: providerModel.merge,
                                                    activeColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    onChanged: (_) {
                                                      setState(() {
                                                        controller.toggleMerge(
                                                            providerModel);
                                                      });
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                                body: AndroidCustomProviderDataTable(
                                  providerModel: providerModel,
                                  columnSpacing:
                                      MediaQuery.of(context).size.width * .02,
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
