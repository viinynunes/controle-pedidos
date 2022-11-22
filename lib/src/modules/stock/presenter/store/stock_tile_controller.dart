import 'package:controle_pedidos/src/domain/models/stock_model.dart';
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
  updateTotalOrderedByButton(bool increase) {
    if (increase) {
      stock.totalOrdered++;
    } else {
      stock.totalOrdered--;
    }

    updateTotalOrderedController();
    updateStockLeft();
    updateStockUsecase(increase);
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
    updateStockUsecase(increase);
  }

  @action
  updateTotalOrderedByKeyboard(String newStock) {
    stockTotalOrderedController.text = newStock;
    stock.totalOrdered = int.parse(newStock);
    updateStockLeft();
    updateStockUsecase(true);
  }

  @action
  updateStockLeft() {
    stockLeft = int.parse(
        (int.parse(stockTotalOrderedController.text) - stock.total).toString());
  }

  @action
  updateStockDate(DateTime date) async {
    final toDeleteStock = StockModel.fromStock(stock);

    stock.registrationDate = date;

    final result = await stockUsecase.updateStockDate(toDeleteStock, stock);

    result.fold((l) => error = optionOf(l), (r) => {});
  }

  updateStockUsecase(bool increase) async {
    final result = searchDatesAreEqual
        ? await stockUsecase.updateStock(stock)
        : await stockUsecase.updateStockByEndDate(stock, endDate, increase);

    result.fold((l) => error = optionOf(l), (r) => {});
  }

  stockTextFieldTap() {
    stockTotalOrderedFocus.requestFocus();
    stockTotalOrderedController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: stockTotalOrderedController.value.text.length);
  }
}
