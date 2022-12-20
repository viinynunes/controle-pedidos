import 'package:controle_pedidos/src/modules/core/widgets/show_entity_selection_dialog.dart';
import 'package:controle_pedidos/src/modules/stock/presenter/store/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../domain/entities/provider.dart';
import '../../../../../../domain/entities/stock.dart';
import '../../../../../core/widgets/shimmer/shimer_widget.dart';
import '../../../store/divide_stock_dialog_controller.dart';

class DivideStockBetweenProvidersDialog extends StatefulWidget {
  const DivideStockBetweenProvidersDialog({Key? key, required this.stock})
      : super(key: key);

  final Stock stock;

  @override
  State<DivideStockBetweenProvidersDialog> createState() =>
      _DivideStockBetweenProvidersDialogState();
}

class _DivideStockBetweenProvidersDialogState
    extends State<DivideStockBetweenProvidersDialog> {
  final stockController = GetIt.I.get<StockController>();
  final divideController = GetIt.I.get<DivideStockDialogController>();

  @override
  void initState() {
    super.initState();

    divideController.initState(widget.stock);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.stock.product.name,
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.all(8),
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
                'Selecione o Fornecedor',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Observer(
                builder: (_) => divideController.loading
                    ? const ShimmerWidget.rectangular(height: 30)
                    : SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            final entity = await showDialog(
                              context: context,
                              builder: (_) => ShowEntitySelectionDialog(
                                  entityList: divideController.providerList),
                            );

                            if (entity != null && entity is Provider) {
                              divideController.setSelectedProvider(entity);
                            }
                          },
                          child: Text(divideController.selectedProvider!.name),
                        ),
                      ),
              ),
              const Divider(),
              Text(
                'Copiar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Observer(
                builder: (context) {
                  return Switch(
                      value: !divideController.movePropertiesAndDelete,
                      onChanged: (e) =>
                          divideController.toggleMovePropertiesAndDelete());
                },
              ),
              Text(
                'Mover',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Observer(
                builder: (context) {
                  return Switch(
                      value: divideController.movePropertiesAndDelete,
                      onChanged: (e) =>
                          divideController.toggleMovePropertiesAndDelete());
                },
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                stockController.createDuplicatedStock(
                    widget.stock,
                    divideController.selectedProvider!,
                    divideController.movePropertiesAndDelete);

                Navigator.of(context).pop();
              },
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        )
      ],
    );
  }
}
