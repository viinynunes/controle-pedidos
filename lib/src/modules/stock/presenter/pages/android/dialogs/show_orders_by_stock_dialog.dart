import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../core/ui/states/base_state.dart';
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

class _ShowOrdersByStockDialogState extends BaseState<ShowOrdersByStockDialog, ShowOrdersByStockDialogController> {
  final stockController = GetIt.I.get<StockController>();
  final dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    controller.initState(
        stock: widget.stock,
        iniDate: stockController.iniDate,
        endDate: stockController.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.stock.product.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Observer(
                  builder: (context) {
                    return ElevatedButton(
                      onLongPress: controller.resetIniDate,
                      onPressed: () async {
                        await showDatePicker(
                                context: context,
                                initialDate: controller.iniDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2200))
                            .then((value) {
                          if (value != null) {
                            controller.setIniDate(value);
                            controller.getOrderListByStock();
                          }
                        });
                      },
                      child: Text(
                        dateFormat.format(controller.iniDate),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Observer(builder: (context) {
                  return ElevatedButton(
                    onLongPress: controller.resetEndDate,
                    onPressed: () async {
                      await showDatePicker(
                              context: context,
                              initialDate: controller.endDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2200))
                          .then((value) {
                        if (value != null) {
                          controller.setEndDate(value);
                          controller.getOrderListByStock();
                        }
                      });
                    },
                    child: Text(
                      dateFormat.format(controller.endDate),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Selecione as datas para buscar os pedidos pelo item selecionado',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.maxFinite,
              child: Observer(
                builder: (_) {
                  if (controller.loading) {
                    return const ShimmerListBuilder(
                      itemCount: 10,
                      height: 40,
                      width: double.maxFinite,
                    );
                  }

                  final orderList = controller.orderListByStock;

                  return controller.orderListByStock.isNotEmpty
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
    );
  }
}
