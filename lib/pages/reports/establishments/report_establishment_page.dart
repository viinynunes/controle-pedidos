import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/services/report_establishment_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportEstablishmentPage extends StatefulWidget {
  const ReportEstablishmentPage({Key? key}) : super(key: key);

  @override
  _ReportEstablishmentPageState createState() =>
      _ReportEstablishmentPageState();
}

class _ReportEstablishmentPageState extends State<ReportEstablishmentPage> {
  bool loading = false;

  final dateFormat = DateFormat('dd-MM-yyyy');
  late DateTime iniDate, endDate;

  List<StockData> StockDataList = [];

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
          title: const Text('Relatório por estabelecimento'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
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
                    child: Text(
                      dateFormat.format(iniDate),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
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
                    child: Text(
                      dateFormat.format(endDate),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      _updateOrderItemList();
                    },
                    child: const Text('Gerar Relatório'),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              loading
                  ? const LinearProgressIndicator()
                  : StockDataList.isEmpty
                      ? const Center(
                          child: Text('Lista Vazia'),
                        )
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: StockDataList.length,
                            itemBuilder: (context, index) {
                              var item = StockDataList[index];
                              return Padding(
                                padding: const EdgeInsets.all(6),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 0.2))),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: Text(item.product.provider.name),
                                      ),
                                      Flexible(
                                        flex: 4,
                                        fit: FlexFit.tight,
                                        child: Text(item.product.name, textAlign: TextAlign.justify,),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(item.product.category, textAlign: TextAlign.end,),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: Text(item.totalOrdered.toString(), textAlign: TextAlign.end,),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: Text((item.totalOrdered - item.total).toString(), textAlign: TextAlign.end,),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ));
  }

  Future<void> _updateOrderItemList() async {
    setState(() {
      loading = true;
    });
    final service = ReportEstablishmentService();
    final list =
        await service.mergeOrderItemsByProvider(context, iniDate, endDate);

    setState(() {
      StockDataList = list;
      loading = false;
    });
  }
}
