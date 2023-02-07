import 'package:auto_size_text/auto_size_text.dart';
import 'package:controle_pedidos/src/modules/stock/presenter/store/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class StockTableHeaderWidget extends StatelessWidget {
  const StockTableHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<StockController>();

    _getStockTableHeader({required int flex, required String text}) {
      return Flexible(
          flex: flex,
          fit: FlexFit.tight,
          child: AutoSizeText(
            text,
            maxLines: 1,
            minFontSize: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ));
    }

    return Observer(
        builder: (_) => controller.stockList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _getStockTableHeader(flex: 8, text: 'Produto'),
                    _getStockTableHeader(flex: 3, text: 'Emb'),
                    _getStockTableHeader(flex: 3, text: 'Pedido'),
                    _getStockTableHeader(flex: 4, text: 'Total'),
                    _getStockTableHeader(flex: 4, text: 'Sobra'),
                  ],
                ),
              )
            : Container());
  }
}
