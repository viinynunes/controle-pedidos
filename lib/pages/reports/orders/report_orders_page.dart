import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/pages/reports/orders/report_one_order_page.dart';
import 'package:controle_pedidos/services/excel_export_service.dart';
import 'package:controle_pedidos/services/order_services.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportOrdersPage extends StatefulWidget {
  const ReportOrdersPage({Key? key}) : super(key: key);

  @override
  _ReportOrdersPageState createState() => _ReportOrdersPageState();
}

class _ReportOrdersPageState extends State<ReportOrdersPage> {
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  late DateTime iniDate, endDate;
  bool loading = false;

  List<OrderData> orderList = [];
  OrderServices orderServices = OrderServices();

  ExcelExportService excelService = ExcelExportService();

  @override
  void initState() {
    super.initState();

    iniDate = DateTime.now();
    endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (orderList.isNotEmpty) {
                  var mergedList =
                      orderServices.mergeOrdersBetweenDifferentDates(orderList);
                  createReport(mergedList);
                }
              },
              icon: const Icon(Icons.share))
        ],
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: desktop ? 1080 : double.maxFinite),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: iniDate,
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime(2050))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                iniDate = value;
                              });
                            }
                          });
                        },
                        child: Text(dateFormat.format(iniDate)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: endDate,
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime(2050))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                endDate = value;
                              });
                            }
                          });
                        },
                        child: Text(dateFormat.format(endDate)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        await _setOrderList();
                      },
                      child: const Text('Gerar Relatório'),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                loading ? const LinearProgressIndicator() : Container(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      var order = orderList[index];
                      return ListTile(
                          onTap: () {
                            orderServices.sortOrderItems(order.orderItemList!);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReportOneOrderPage(order: order)));
                          },
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  dateFormat.format(order.creationDate),
                                  style: _getStyle(),
                                ),
                                flex: 2,
                                fit: FlexFit.tight,
                              ),
                              Flexible(
                                child: Text(
                                  order.client.name,
                                  style: _getStyle(),
                                ),
                                flex: 3,
                                fit: FlexFit.tight,
                              ),
                              Flexible(
                                child: Text(
                                  order.lengthOrderItemList.toString(),
                                  style: _getStyle(),
                                ),
                                flex: 2,
                                fit: FlexFit.tight,
                              ),
                            ],
                          ));
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

  Future<void> _setOrderList() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
      final list = await OrderModel.of(context)
          .getEnabledOrdersBetweenDates(iniDate, endDate);

      setState(() {
        orderList = list;
        loading = false;
      });
    }
  }

  void createReport(List<OrderData> mergedOrderList) {
    excelService.createAndOpenExcelToOrder(mergedOrderList);
  }

  TextStyle _getStyle(){
    return const TextStyle(color: CustomColors.textColorTile);
  }
}
