import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../store/stock_tile_controller.dart';

class AndroidStockTile extends StatefulWidget {
  const AndroidStockTile({Key? key, required this.stock}) : super(key: key);

  final Stock stock;

  @override
  State<AndroidStockTile> createState() => _AndroidStockTileState();
}

class _AndroidStockTileState extends State<AndroidStockTile> {
  final controller = GetIt.I.get<StockTileController>();

  @override
  void initState() {
    super.initState();

    controller.initState(widget.stock);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          _getFlexible(flex: 8, text: controller.stock.product.name),
          _getFlexible(flex: 2, text: controller.stock.product.category),
          _getFlexible(flex: 4, text: controller.stock.total.toString()),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: TextField(
              controller: controller.stockTotalOrderedController,
              focusNode: controller.stockTotalOrderedFocus,
              textAlign: TextAlign.center,
              onTap: controller.stockTextFieldTap,
              onSubmitted: (newStock) {
                controller.stockTotalOrderedController.text = newStock;
                controller.updateStockLeft();
              },
              keyboardType: const TextInputType.numberWithOptions(),
              textInputAction: TextInputAction.next,
            ),
          ),
          Observer(
            builder: (_) =>
                _getFlexible(flex: 4, text: controller.stockLeft.toString()),
          ),
        ],
      ),
    );
  }

  _getFlexible({required int flex, required String text}) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
