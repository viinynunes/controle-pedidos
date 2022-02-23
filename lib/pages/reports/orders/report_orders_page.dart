import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/pages/reports/orders/report_one_order_page.dart';
import 'package:controle_pedidos/services/order_services.dart';
import 'package:controle_pedidos/utils/export_to_pdf.dart';
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

  @override
  void initState() {
    super.initState();

    iniDate = DateTime.now();
    endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (orderList.isNotEmpty) {
                  var mergedList = orderServices.mergeOrdersBetweenDifferentDates(orderList);
                  createReport(mergedList);
                }
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: Padding(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReportOneOrderPage(order: order)));
                    },
                    title: Text(dateFormat.format(order.creationDate) +
                        ' - ' +
                        order.client.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setOrderList() async {
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

  void createReport(List<OrderData> mergedOrderList) {
    ExportToPDF.createPDF(mergedOrderList);
  }
}
