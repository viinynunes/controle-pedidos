import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/widgets/shimmer/shimmer_list_builder.dart';
import '../../../../../../domain/entities/stock.dart';
import '../../../store/show_orders_by_stock_dialog_controller.dart';
import '../../../store/stock_controller.dart';

class ShowOrdersByStockDialog extends StatefulWidget {
  const ShowOrdersByStockDialog({Key? key, required this.stock})
      : super(key: key);

  final Stock stock;

  @override
  State<ShowOrdersByStockDialog> createState() =>
      _ShowOrdersByStockDialogState();
}

class _ShowOrdersByStockDialogState extends State<ShowOrdersByStockDialog> {
  final stockController = GetIt.I.get<StockController>();
  final dialogController = GetIt.I.get<ShowOrdersByStockDialogController>();
  final dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();

    dialogController.initState(
        stock: widget.stock,
        iniDate: stockController.iniDate,
        endDate: stockController.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.stock.product.name,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Selecione as datas para buscar os pedidos pelo item selecionado',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Observer(builder: (context) {
                      return ElevatedButton(
                        onLongPress: dialogController.resetIniDate,
                        onPressed: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: dialogController.iniDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2200))
                              .then((value) {
                            if (value != null) {
                              dialogController.setIniDate(value);
                              dialogController.getOrderListByStock();
                            }
                          });
                        },
                        child: Text(
                          dateFormat.format(dialogController.iniDate),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Observer(builder: (context) {
                      return ElevatedButton(
                        onLongPress: dialogController.resetEndDate,
                        onPressed: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: dialogController.endDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2200))
                              .then((value) {
                            if (value != null) {
                              dialogController.setEndDate(value);
                              dialogController.getOrderListByStock();
                            }
                          });
                        },
                        child: Text(
                          dateFormat.format(dialogController.endDate),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Observer(
                  builder: (_) {
                    if (dialogController.loading) {
                      return const ShimmerListBuilder(
                        itemCount: 10,
                        height: 40,
                        width: double.maxFinite,
                      );
                    }

                    final orderList = dialogController.orderListByStock;

                    return dialogController.orderListByStock.isNotEmpty
                        ? ListView.builder(
                            itemCount: orderList.length,
                            itemBuilder: (_, index) {
                              final order = orderList[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                                '${order.orderItemList.single.quantity}   ${order.orderItemList.single.product.category}')),
                                        Flexible(
                                          flex: 6,
                                          fit: FlexFit.tight,
                                          child: Column(
                                            children: [
                                              Text(order.client.name),
                                              Text(
                                                dateFormat.format(
                                                    order.registrationDate),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text('Nenhum pedido encontrado'),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
