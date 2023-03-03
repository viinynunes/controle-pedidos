import 'package:controle_pedidos/src/core/ui/user_tips/tipsController.dart';
import 'package:controle_pedidos/src/core/ui/user_tips/report_tutorial_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/admob/admob_helper.dart';
import '../../../../../../core/export_files/order_to_xlsx.dart';
import '../../../../../../core/helpers/custom_page_route.dart';
import '../../../../../../core/reports/menu/modal_bottom_menu_export_options.dart';
import '../../../../../../core/ui/states/base_state.dart';
import '../../../../../../core/widgets/custom_date_range_picker_widget.dart';
import '../../../stores/order_report_controller.dart';
import '../tiles/android_order_list_tile.dart';
import 'order_to_image.dart';

class AndroidOrderReportPage extends StatefulWidget {
  const AndroidOrderReportPage({Key? key}) : super(key: key);

  @override
  State<AndroidOrderReportPage> createState() => _AndroidOrderReportPageState();
}

class _AndroidOrderReportPageState
    extends BaseState<AndroidOrderReportPage, OrderReportController> {
  final adHelper = AdMobHelper();

  final tipController = GetIt.I.get<TipsController>();

  @override
  void initState() {
    super.initState();

    if (controller.showBannerAd()) {
      adHelper.createRewardedAd();
    }
    controller.initState();
  }

  @override
  onReady() {
    if (tipController.showOrderReportTip()) {
      showTutorialDialog();
    }
  }

  showTutorialDialog() async {
    await showDialog(
      context: context,
      builder: (_) => TipsDialog(
        message:
            'Para visualizar o relatório, é necessário ter instalado algum aplicativo visualizador de xlsx, como o Excel ou o Sheets',
        onDontShowAgain: tipController.disableOrderReportTip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Pedidos'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (controller.showBannerAd()) {
            adHelper.showRewardedAd();
          }

          showTutorialDialog();

          controller.mergeOrderList();
          showModalBottomSheet(
            context: context,
            builder: (_) => ModalBottomMenuExportOptions(
              onGenerateXLSX: () {
                OrderToXLSX().exportOrder(controller.mergedOrderList);
              },
            ),
          );
        },
        label: const Text('Gerar'),
        icon: const Icon(Icons.upload_file),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                Expanded(
                  child: Observer(
                    builder: (_) {
                      if (controller.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final orderList = controller.orderList;

                      return orderList.isNotEmpty
                          ? ListView.builder(
                              itemCount: orderList.length,
                              itemBuilder: (_, index) {
                                final order = orderList[index];
                                return AndroidOrderListTile(
                                  order: order,
                                  onTap: () => Navigator.of(context).push(
                                    CustomPageRoute(
                                        child: OrderToImage(order: order),
                                        direction: AxisDirection.left),
                                  ),
                                  onDisable: () {},
                                );
                              },
                            )
                          : const Center(
                              child: Text('Nenhum pedido encontrado'),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
