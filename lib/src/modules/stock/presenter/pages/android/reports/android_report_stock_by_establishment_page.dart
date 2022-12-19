import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.arrow_right_alt),
        onPressed: () {},
        label: const Text('Gerar'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Padding(
            padding: const EdgeInsets.all(8),
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
                        children: controller.establishmentList.map(
                              (establishment) =>
                              ExpansionPanelRadio(
                                  value: UniqueKey(),
                                  canTapOnHeader: true,
                                  headerBuilder: (_, isOpen) {
                                    return Container(
                                      color: Colors.red,
                                      child: const Text('Title'),
                                    );
                                  },
                                  body: Container(
                                    color: Colors.blue,
                                    child: const Text('body'),
                                  )),
                        ).toList(),
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
