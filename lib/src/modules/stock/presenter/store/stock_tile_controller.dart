import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/stock.dart';

part 'stock_tile_controller.g.dart';

class StockTileController = _StockTileControllerBase with _$StockTileController;

abstract class _StockTileControllerBase with Store {
  @observable
  int stockLeft = 0;

  late Stock stock;

  final stockTotalOrderedController = TextEditingController();

  final stockTotalOrderedFocus = FocusNode();

  @action
  initState(Stock stock) {
    this.stock = stock;

    stockTotalOrderedController.text = stock.totalOrdered.toString();

    updateStockLeft();
  }

  @action
  updateStockLeft() {
    stockLeft = int.parse(
        (int.parse(stockTotalOrderedController.text) - stock.total).toString());
  }

  stockTextFieldTap() {
    stockTotalOrderedFocus.requestFocus();
    stockTotalOrderedController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: stockTotalOrderedController.value.text.length);
  }
}
