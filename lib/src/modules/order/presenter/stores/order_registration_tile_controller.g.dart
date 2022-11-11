// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_registration_tile_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderRegistrationTileController
    on _OrderRegistrationTileControllerBase, Store {
  late final _$quantityAtom = Atom(
      name: '_OrderRegistrationTileControllerBase.quantity', context: context);

  @override
  int get quantity {
    _$quantityAtom.reportRead();
    return super.quantity;
  }

  @override
  set quantity(int value) {
    _$quantityAtom.reportWrite(value, super.quantity, () {
      super.quantity = value;
    });
  }

  late final _$_OrderRegistrationTileControllerBaseActionController =
      ActionController(
          name: '_OrderRegistrationTileControllerBase', context: context);

  @override
  dynamic initState(OrderItem item) {
    final _$actionInfo = _$_OrderRegistrationTileControllerBaseActionController
        .startAction(name: '_OrderRegistrationTileControllerBase.initState');
    try {
      return super.initState(item);
    } finally {
      _$_OrderRegistrationTileControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateQuantity(bool increase) {
    final _$actionInfo =
        _$_OrderRegistrationTileControllerBaseActionController.startAction(
            name: '_OrderRegistrationTileControllerBase.updateQuantity');
    try {
      return super.updateQuantity(increase);
    } finally {
      _$_OrderRegistrationTileControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
quantity: ${quantity}
    ''';
  }
}
