import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../core/helpers.dart';
import '../../../../../../core/helpers/custom_page_route.dart';
import '../../../../../../core/widgets/add_remove_quantity_widget.dart';
import '../../../../../../domain/entities/product.dart';
import '../../../../../../domain/entities/stock.dart';
import '../../../../../product/presenter/pages/android/pages/android_product_registration_page.dart';
import '../../../store/stock_controller.dart';
import '../../../store/stock_tile_controller.dart';
import 'modal_bottom_sheet_stock_tile.dart';

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
      tileController.initState(
          stock: widget.stock,
          searchDatesAreEqual: Helpers.compareOnlyDateFromDateTime(
              stockController.iniDate, stockController.endDate),
          endDate: stockController.endDate);
    });

    tileController.initState(
        stock: widget.stock,
        searchDatesAreEqual: Helpers.compareOnlyDateFromDateTime(
            stockController.iniDate, stockController.endDate),
        endDate: stockController.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => GestureDetector(
        onDoubleTap: () {
          tileController.setSelected();
          stockController.addRemoveStockFromSelectedStockList(widget.stock);
        },
        child: Card(
          color: tileController.selected
              ? Theme.of(context).indicatorColor
              : Theme.of(context).cardColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  builder: (_) => ModalBottomSheetStockTile(
                    stock: widget.stock,
                    onEditProduct: () async {
                      Navigator.of(context).pop();

                      await Navigator.of(context)
                          .push(
                        CustomPageRoute(
                            child: AndroidProductRegistrationPage(
                              product: widget.stock.product,
                            ),
                            direction: AxisDirection.left),
                      )
                          .then((result) async {
                        if (result != null && result is Product) {
                          await stockController
                              .reloadProviderListAndStockList(result.provider);
                        }
                      });
                    },
                    onDelete: () => stockController.removeStock(widget.stock),
                    equalDates: Helpers.compareOnlyDateFromDateTime(
                        stockController.iniDate, stockController.endDate),
                    onChangeDate: (date) async {
                      await tileController.updateStockDate(date);
                      await stockController
                          .getStockListByProviderBetweenDates();
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  const SizedBox(width: 0.8),
                  _getFlexible(
                      flex: 5, text: tileController.stock.product.name),
                  _getFlexible(
                      flex: 2, text: tileController.stock.product.category),
                  _getFlexible(
                      flex: 2, text: tileController.stock.total.toString()),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: TextField(
                      enabled: Helpers.compareOnlyDateFromDateTime(
                          stockController.iniDate, stockController.endDate),
                      controller: tileController.stockTotalOrderedController,
                      focusNode: tileController.stockTotalOrderedFocus,
                      textAlign: TextAlign.center,
                      onTap: tileController.stockTextFieldTap,
                      onSubmitted: tileController.updateTotalOrderedByKeyboard,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      style: tileController.selected
                          ? const TextStyle(color: Colors.black)
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AddRemoveQuantityWidget(
                          onTap: () =>
                              tileController.increaseStockTotalOrderedByButton(),
                          icon: Icons.add_circle_sharp,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        AddRemoveQuantityWidget(
                          onTap: () =>
                              tileController.decreaseStockTotalOrderedByButton(),
                          icon: Icons.remove_circle_sharp,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  Observer(
                    builder: (_) => _getFlexible(
                        flex: 1, text: tileController.stockLeft.toString()),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AddRemoveQuantityWidget(
                          onTap: () =>
                              tileController.increaseStockTotalOrderedFromStockLeft(),
                          icon: Icons.add_circle_sharp,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        AddRemoveQuantityWidget(
                          onTap: () =>
                              tileController.decreaseStockTotalOrderedFromStockLeft(),
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
        style: tileController.selected
            ? const TextStyle(color: Colors.black)
            : Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
