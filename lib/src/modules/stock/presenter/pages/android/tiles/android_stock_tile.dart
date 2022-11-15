import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/widgets/add_remove_quantity_widget.dart';
import '../../../store/stock_controller.dart';
import '../../../store/stock_tile_controller.dart';

class AndroidStockTile extends StatefulWidget {
  const AndroidStockTile(
      {Key? key, required this.stock, required this.onRemove})
      : super(key: key);

  final Stock stock;
  final VoidCallback onRemove;

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
    return Slidable(
      direction: Axis.horizontal,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (e) => widget.onRemove(),
            icon: Icons.delete,
            backgroundColor: Theme.of(context).errorColor,
            autoClose: false,
            borderRadius: BorderRadius.circular(50),
            spacing: 10,
          ),
        ],
      ),
      child: Card(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              _getFlexible(flex: 8, text: tileController.stock.product.name),
              _getFlexible(
                  flex: 2, text: tileController.stock.product.category),
              _getFlexible(
                  flex: 4, text: tileController.stock.total.toString()),
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
                    AddRemoveQuantityWidget(
                      onTap: () =>
                          tileController.updateTotalOrderedByButton(true),
                      icon: Icons.add_circle_sharp,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    AddRemoveQuantityWidget(
                      onTap: () =>
                          tileController.updateTotalOrderedByButton(false),
                      icon: Icons.remove_circle_sharp,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              Observer(
                builder: (_) => _getFlexible(
                    flex: 3, text: tileController.stockLeft.toString()),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddRemoveQuantityWidget(
                      onTap: () => tileController.updateStockLeftByButton(true),
                      icon: Icons.add_circle_sharp,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    AddRemoveQuantityWidget(
                      onTap: () =>
                          tileController.updateStockLeftByButton(false),
                      icon: Icons.remove_circle_sharp,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
