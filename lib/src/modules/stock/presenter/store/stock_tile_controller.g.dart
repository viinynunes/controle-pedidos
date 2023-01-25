// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_tile_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StockTileController on _StockTileControllerBase, Store {
  late final _$stockLeftAtom =
      Atom(name: '_StockTileControllerBase.stockLeft', context: context);

  @override
  int get stockLeft {
    _$stockLeftAtom.reportRead();
    return super.stockLeft;
  }

  @override
  set stockLeft(int value) {
    _$stockLeftAtom.reportWrite(value, super.stockLeft, () {
      super.stockLeft = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_StockTileControllerBase.error', context: context);

  @override
  Option<StockError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<StockError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$selectedAtom =
      Atom(name: '_StockTileControllerBase.selected', context: context);

  @override
  bool get selected {
    _$selectedAtom.reportRead();
    return super.selected;
  }

  @override
  set selected(bool value) {
    _$selectedAtom.reportWrite(value, super.selected, () {
      super.selected = value;
    });
  }

  late final _$searchDatesAreEqualAtom = Atom(
      name: '_StockTileControllerBase.searchDatesAreEqual', context: context);

  @override
  bool get searchDatesAreEqual {
    _$searchDatesAreEqualAtom.reportRead();
    return super.searchDatesAreEqual;
  }

  @override
  set searchDatesAreEqual(bool value) {
    _$searchDatesAreEqualAtom.reportWrite(value, super.searchDatesAreEqual, () {
      super.searchDatesAreEqual = value;
    });
  }

  late final _$updateStockDateAsyncAction =
      AsyncAction('_StockTileControllerBase.updateStockDate', context: context);

  @override
  Future updateStockDate(DateTime date) {
    return _$updateStockDateAsyncAction.run(() => super.updateStockDate(date));
  }

  late final _$_StockTileControllerBaseActionController =
      ActionController(name: '_StockTileControllerBase', context: context);

  @override
  dynamic initState(
      {required Stock stock,
      required bool searchDatesAreEqual,
      required DateTime endDate}) {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.initState');
    try {
      return super.initState(
          stock: stock,
          searchDatesAreEqual: searchDatesAreEqual,
          endDate: endDate);
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelected() {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.setSelected');
    try {
      return super.setSelected();
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateTotalOrderedController() {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.updateTotalOrderedController');
    try {
      return super.updateTotalOrderedController();
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic increaseStockTotalOrderedByButton() {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.increaseStockTotalOrderedByButton');
    try {
      return super.increaseStockTotalOrderedByButton();
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic decreaseStockTotalOrderedByButton() {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.decreaseStockTotalOrderedByButton');
    try {
      return super.decreaseStockTotalOrderedByButton();
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateStockLeftByButton(bool increase) {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.updateStockLeftByButton');
    try {
      return super.updateStockLeftByButton(increase);
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateTotalOrderedByKeyboard(String newStock) {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.updateTotalOrderedByKeyboard');
    try {
      return super.updateTotalOrderedByKeyboard(newStock);
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateStockLeft() {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.updateStockLeft');
    try {
      return super.updateStockLeft();
    } finally {
      _$_StockTileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
stockLeft: ${stockLeft},
error: ${error},
selected: ${selected},
searchDatesAreEqual: ${searchDatesAreEqual}
    ''';
  }
}
