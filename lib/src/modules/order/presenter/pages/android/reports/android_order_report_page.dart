import 'package:controle_pedidos/src/modules/core/helpers/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../stores/order_report_controller.dart';
import '../tiles/android_order_list_tile.dart';
import 'order_to_image.dart';

class AndroidOrderReportPage extends StatefulWidget {
  const AndroidOrderReportPage({Key? key}) : super(key: key);

  @override
  State<AndroidOrderReportPage> createState() => _AndroidOrderReportPageState();
}

class _AndroidOrderReportPageState extends State<AndroidOrderReportPage> {
  final controller = GetIt.I.get<OrderReportController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Pedidos'),
        actions: [
          IconButton(
            onPressed: () {
              controller.mergeOrderList();
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
