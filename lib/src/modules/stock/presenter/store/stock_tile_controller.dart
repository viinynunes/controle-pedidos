import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/stock.dart';
import '../../domain/usecases/change_stock_date_usecase.dart';
import '../../domain/usecases/decrease_stock_total_ordered_usecase.dart';
import '../../domain/usecases/increase_stock_total_ordered_usecase.dart';
import '../../domain/usecases/update_stock_usecase.dart';

part 'stock_tile_controller.g.dart';

class StockTileController = _StockTileControllerBase with _$StockTileController;

abstract class _StockTileControllerBase with Store {
  final UpdateStockUsecase updateStockUsecase;
  final IncreaseStockTotalOrderedUsecase increaseStockTotalOrderedUsecase;
  final DecreaseStockTotalOrderedUsecase decreaseStockTotalOrderedUsecase;
  final ChangeStockDateUsecase changeStockDateUsecase;

  _StockTileControllerBase(
      this.updateStockUsecase,
      this.increaseStockTotalOrderedUsecase,
      this.decreaseStockTotalOrderedUsecase,
      this.changeStockDateUsecase);

  @observable
  int stockLeft = 0;
  @observable
  Option<StockError> error = none();
  @observable
  bool selected = false;
  @observable
  bool searchDatesAreEqual = true;

  late Stock stock;
  late DateTime endDate;
  final stockTotalOrderedController = TextEditingController();

  final stockTotalOrderedFocus = FocusNode();

  @action
  initState(
      {required Stock stock,
      required bool searchDatesAreEqual,
      required DateTime endDate}) {
    this.stock = stock;
    this.searchDatesAreEqual = searchDatesAreEqual;
    this.endDate = endDate;

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
  increaseStockTotalOrderedByButton() {
    stock.totalOrdered++;

    increaseStockTotalOrderedUsecase(increaseQuantity: 1, stockID: stock.id);
    updateTotalOrderedController();
    updateStockLeft();
  }

  @action
  decreaseStockTotalOrderedByButton() {
    stock.totalOrdered--;

    decreaseStockTotalOrderedUsecase(decreaseQuantity: 1, stockID: stock.id);
    updateTotalOrderedController();
    updateStockLeft();
  }

  @action
  updateTotalOrderedByKeyboard(String newStock) {
    stock.totalOrdered = int.parse(newStock);

    updateStockUsecase(stock);

    updateTotalOrderedController();
    updateStockLeft();
  }

  @action
  increaseStockTotalOrderedFromStockLeft() {
    if (stockLeft.isNegative) {
      stockLeft = 0;
      stock.totalOrdered = stock.total;
    }

    stockLeft++;
    stock.totalOrdered++;

    updateStockUsecase(stock);

    updateTotalOrderedController();
  }

  @action
  decreaseStockTotalOrderedFromStockLeft() {
    stockLeft--;
    stock.totalOrdered--;

    updateTotalOrderedController();
    updateStockUsecase(stock);
    updateTotalOrderedController();
  }

  @action
  updateStockLeft() {
    stockLeft = int.parse(
        (int.parse(stockTotalOrderedController.text) - stock.total).toString());
  }

  @action
  changeStockDate(DateTime date) async {
    final result = await changeStockDateUsecase(stockId: stock.id, newDate: date);

    result.fold((l) => error = optionOf(l), (r) => {});
  }

  stockTextFieldTap() {
    stockTotalOrderedFocus.requestFocus();
    stockTotalOrderedController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: stockTotalOrderedController.value.text.length);
  }
}
