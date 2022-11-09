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

  late final _$_StockTileControllerBaseActionController =
      ActionController(name: '_StockTileControllerBase', context: context);

  @override
  dynamic initState(Stock stock) {
    final _$actionInfo = _$_StockTileControllerBaseActionController.startAction(
        name: '_StockTileControllerBase.initState');
    try {
      return super.initState(stock);
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
stockLeft: ${stockLeft}
    ''';
  }
}
