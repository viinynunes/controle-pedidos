// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_registration_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClientRegistrationController on ClientRegistrationBase, Store {
  late final _$enabledAtom =
      Atom(name: 'ClientRegistrationBase.enabled', context: context);

  @override
  bool get enabled {
    _$enabledAtom.reportRead();
    return super.enabled;
  }

  @override
  set enabled(bool value) {
    _$enabledAtom.reportWrite(value, super.enabled, () {
      super.enabled = value;
    });
  }

  late final _$ClientRegistrationBaseActionController =
      ActionController(name: 'ClientRegistrationBase', context: context);

  @override
  dynamic changeEnabled(dynamic newEnabled) {
    final _$actionInfo = _$ClientRegistrationBaseActionController.startAction(
        name: 'ClientRegistrationBase.changeEnabled');
    try {
      return super.changeEnabled(newEnabled);
    } finally {
      _$ClientRegistrationBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
enabled: ${enabled}
    ''';
  }
}
