import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../core/ui/states/base_state.dart';
import '../../../../../../core/widgets/shimmer/shimer_widget.dart';
import '../../../../../../core/widgets/show_entity_selection_dialog.dart';
import '../../../../../../domain/entities/provider.dart';
import '../../../../../../domain/entities/stock.dart';
import '../../../store/divide_stock_dialog_controller.dart';
import '../../../store/stock_controller.dart';

class DivideStockBetweenProvidersDialog extends StatefulWidget {
  const DivideStockBetweenProvidersDialog({Key? key, required this.stock})
      : super(key: key);

  final Stock stock;

  @override
  State<DivideStockBetweenProvidersDialog> createState() =>
      _DivideStockBetweenProvidersDialogState();
}

class _DivideStockBetweenProvidersDialogState extends BaseState<
    DivideStockBetweenProvidersDialog, DivideStockDialogController> {
  final stockController = GetIt.I.get<StockController>();

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    controller.initState(widget.stock);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.stock.product.name,
        textAlign: TextAlign.center,
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categoria: ${widget.stock.product.category}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Quantidade: ${widget.stock.total.toString()}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Total : ${widget.stock.totalOrdered.toString()}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Fornecedor Atual: ${widget.stock.product.provider.name}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Divider(),
              Text(
                'Selecione o Novo Fornecedor',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Observer(
                builder: (_) => controller.loading
                    ? const ShimmerWidget.rectangular(height: 30)
                    : SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            final entity = await showDialog(
                              context: context,
                              builder: (_) => ShowEntitySelectionDialog(
                                  entityList: controller.providerList),
                            );

                            if (entity != null && entity is Provider) {
                              controller.setSelectedProvider(entity);
                            }
                          },
                          child: Text(controller.selectedProvider!.name),
                        ),
                      ),
              ),
              const Divider(),
              Text(
                'Duplicar',
                selectionColor: Colors.blue,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Duplica o estoque para outro fornecedor sem levar seus atributos(pedido, total e sobra)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(),
              Text(
                'Mover',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Move o estoque para outro fornecedor levando seus atributos(pedido, total e sobra)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newProvider = controller.selectedProvider!;

                await controller.moveStockWithProperties(
                    stockID: widget.stock.id, newProvider: newProvider);

                await stockController.getProviderListByStockBetweenDates();

                if (stockController.providerList.contains(
                    controller.stock?.product.provider ?? newProvider)) {
                  await stockController.reloadProviderListAndStockList(
                      controller.stock?.product.provider ?? newProvider);
                } else {
                  await stockController
                      .reloadProviderListAndStockList(newProvider);
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                'Mover',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newProvider = controller.selectedProvider!;

                await controller.duplicateStockWithoutProperties(
                    stockID: widget.stock.id, newProvider: newProvider);

                await stockController
                    .reloadProviderListAndStockList(newProvider);

                Navigator.of(context).pop();
              },
              child: const Text(
                'Duplicar',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
