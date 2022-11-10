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

    updateTotalOrderedController();

    updateStockLeft();
  }

  @action
  updateTotalOrderedController() {
    stockTotalOrderedController.text = stock.totalOrdered.toString();
  }

  stockTextFieldTap() {
    stockTotalOrderedFocus.requestFocus();
    stockTotalOrderedController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: stockTotalOrderedController.value.text.length);
  }

  @action
  updateStockLeft() {
    stockLeft = int.parse(
        (int.parse(stockTotalOrderedController.text) - stock.total).toString());
  }

  @action
  updateTotalOrderedByButton(bool increase) {
    if (increase) {
      stock.totalOrdered++;
    } else {
      stock.totalOrdered--;
    }

    updateTotalOrderedController();
    updateStockLeft();
  }

  @action
  updateStockLeftByButton(bool increase) {
    if (increase) {
      if (stockLeft.isNegative) {
        stockLeft = 0;
        stock.totalOrdered = stock.total;
      }
      stockLeft++;
      stock.totalOrdered++;
    } else {
      stockLeft--;
      stock.totalOrdered--;
    }

    updateTotalOrderedController();
  }

  @action
  updateTotalOrderedByKeyboard(String newStock){
    stockTotalOrderedController.text = newStock;
    stock.totalOrdered = int.parse(newStock);
    updateStockLeft();
  }
}
