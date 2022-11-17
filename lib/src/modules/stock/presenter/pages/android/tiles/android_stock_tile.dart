import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:rect_getter/rect_getter.dart';

import '../../../../../core/widgets/add_remove_quantity_widget.dart';
import '../../../store/stock_controller.dart';
import '../../../store/stock_tile_controller.dart';

class AndroidStockTile extends StatefulWidget {
  const AndroidStockTile(
      {Key? key,
      required this.stock,
      required this.onRemove,
      required this.onLongPress})
      : super(key: key);

  final Stock stock;
  final VoidCallback onRemove;
  final VoidCallback onLongPress;

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

  _showTileMenu() async {
    final rect = RectGetter.getRectFromKey(tileController.rectKey);

    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            rect!.left, rect.top, rect.right, rect.bottom),
        items: [
          PopupMenuItem(
            child: Text(
              widget.stock.product.name.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            enabled: false,
          ),
          PopupMenuItem(onTap: () {}, child: const Text('alterar data')),
        ],
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      endActionPane: ActionPane(
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
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          RectGetter(
            key: tileController.rectKey,
            child: SlidableAction(
              onPressed: (_) async {
                await _showTileMenu();
              },
              icon: Icons.menu_sharp,
              backgroundColor: Theme.of(context).highlightColor,
              autoClose: true,
              borderRadius: BorderRadius.circular(50),
              spacing: 10,
            ),
          )
        ],
      ),
      child: InkWell(
        onLongPress: () {
          tileController.setSelected();
          widget.onLongPress();
        },
        child: Observer(
          builder: (_) => Card(
            color: tileController.selected
                ? Theme.of(context).backgroundColor.withOpacity(0.5)
                : Theme.of(context).cardColor,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  _getFlexible(
                      flex: 8, text: tileController.stock.product.name),
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
                          onTap: () =>
                              tileController.updateStockLeftByButton(true),
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
