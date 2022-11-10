import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../store/stock_controller.dart';
import '../../../store/stock_tile_controller.dart';

class AndroidStockTile extends StatefulWidget {
  const AndroidStockTile({Key? key, required this.stock}) : super(key: key);

  final Stock stock;

  @override
  State<AndroidStockTile> createState() => _AndroidStockTileState();
}

class _AndroidStockTileState extends State<AndroidStockTile> {
  final tileController = GetIt.I.get<StockTileController>();
  final stockController = GetIt.I.get<StockController>();

  @override
  void initState() {
    super.initState();

    reaction((p0) => stockController.stockList, (p0) {
      tileController.initState(widget.stock);
    });

    tileController.initState(widget.stock);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _getFlexible(flex: 8, text: tileController.stock.product.name),
            _getFlexible(flex: 2, text: tileController.stock.product.category),
            _getFlexible(flex: 4, text: tileController.stock.total.toString()),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: TextField(
                controller: tileController.stockTotalOrderedController,
                focusNode: tileController.stockTotalOrderedFocus,
                textAlign: TextAlign.center,
                onTap: tileController.stockTextFieldTap,
                onSubmitted: tileController.updateTotalOrderedByKeyboard,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => tileController.updateTotalOrderedByButton(true),
                    child: const Icon(
                      Icons.add_circle_sharp,
                      size: 15,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => tileController.updateTotalOrderedByButton(false),
                    child: const Icon(
                      Icons.remove_circle_sharp,
                      size: 15,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Observer(
              builder: (_) =>
                  _getFlexible(flex: 3, text: tileController.stockLeft.toString()),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => tileController.updateStockLeftByButton(true),
                    child: const Icon(
                      Icons.add_circle_sharp,
                      size: 15,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => tileController.updateStockLeftByButton(false),
                    child: const Icon(
                      Icons.remove_circle_sharp,
                      size: 15,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
