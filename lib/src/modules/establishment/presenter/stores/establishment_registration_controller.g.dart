// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'establishment_registration_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EstablishmentRegistrationController
    on _EstablishmentRegistrationControllerBase, Store {
  late final _$enabledAtom = Atom(
      name: '_EstablishmentRegistrationControllerBase.enabled',
      context: context);

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

  late final _$newEstablishmentAtom = Atom(
      name: '_EstablishmentRegistrationControllerBase.newEstablishment',
      context: context);

  @override
  bool get newEstablishment {
    _$newEstablishmentAtom.reportRead();
    return super.newEstablishment;
  }

  @override
  set newEstablishment(bool value) {
    _$newEstablishmentAtom.reportWrite(value, super.newEstablishment, () {
      super.newEstablishment = value;
    });
  }

  late final _$successAtom = Atom(
      name: '_EstablishmentRegistrationControllerBase.success',
      context: context);

  @override
  Option<bool> get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(Option<bool> value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$errorAtom = Atom(
      name: '_EstablishmentRegistrationControllerBase.error', context: context);

  @override
  Option<EstablishmentInfoException> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<EstablishmentInfoException> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$_EstablishmentRegistrationControllerBaseActionController =
      ActionController(
          name: '_EstablishmentRegistrationControllerBase', context: context);

  @override
  dynamic initState(Establishment? establishment) {
    final _$actionInfo =
        _$_EstablishmentRegistrationControllerBaseActionController.startAction(
            name: '_EstablishmentRegistrationControllerBase.initState');
    try {
      return super.initState(establishment);
    } finally {
      _$_EstablishmentRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeEnabled(dynamic value) {
    final _$actionInfo =
        _$_EstablishmentRegistrationControllerBaseActionController.startAction(
            name: '_EstablishmentRegistrationControllerBase.changeEnabled');
    try {
      return super.changeEnabled(value);
    } finally {
      _$_EstablishmentRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
enabled: ${enabled},
newEstablishment: ${newEstablishment},
success: ${success},
error: ${error}
    ''';
  }
}
