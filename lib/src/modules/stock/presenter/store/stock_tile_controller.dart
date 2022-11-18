import 'package:controle_pedidos/src/modules/stock/domain/usecases/i_stock_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/stock.dart';

part 'stock_tile_controller.g.dart';

class StockTileController = _StockTileControllerBase with _$StockTileController;

abstract class _StockTileControllerBase with Store {
  final IStockUsecase stockUsecase;

  _StockTileControllerBase(this.stockUsecase);

  @observable
  int stockLeft = 0;
  @observable
  Option<StockError> error = none();
  @observable
  bool selected = false;

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
  setSelected() {
    selected = !selected;
  }

  @action
  updateTotalOrderedController() {
    stockTotalOrderedController.text = stock.totalOrdered.toString();
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
    updateStockUsecase();
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
    updateStockUsecase();
  }

  @action
  updateTotalOrderedByKeyboard(String newStock) {
    stockTotalOrderedController.text = newStock;
    stock.totalOrdered = int.parse(newStock);
    updateStockLeft();
    updateStockUsecase();
  }

  @action
  updateStockLeft() {
    stockLeft = int.parse(
        (int.parse(stockTotalOrderedController.text) - stock.total).toString());
  }

  updateStockUsecase() async {
    final result = await stockUsecase.updateStock(stock);

    result.fold((l) => error = optionOf(l), (r) => {});
  }

  stockTextFieldTap() {
    stockTotalOrderedFocus.requestFocus();
    stockTotalOrderedController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: stockTotalOrderedController.value.text.length);
  }
}
