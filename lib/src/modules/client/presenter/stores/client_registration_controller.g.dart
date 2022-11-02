// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_registration_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClientRegistrationController on _ClientRegistrationBase, Store {
  late final _$enabledAtom =
      Atom(name: '_ClientRegistrationBase.enabled', context: context);

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

  late final _$errorAtom =
      Atom(name: '_ClientRegistrationBase.error', context: context);

  @override
  Option<ClientError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<ClientError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$successAtom =
      Atom(name: '_ClientRegistrationBase.success', context: context);

  @override
  Option<Client> get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(Option<Client> value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$saveOrUpdateAsyncAction =
      AsyncAction('_ClientRegistrationBase.saveOrUpdate', context: context);

  @override
  Future saveOrUpdate(BuildContext context) {
    return _$saveOrUpdateAsyncAction.run(() => super.saveOrUpdate(context));
  }

  late final _$_ClientRegistrationBaseActionController =
      ActionController(name: '_ClientRegistrationBase', context: context);

  @override
  dynamic changeEnabled(dynamic newEnabled) {
    final _$actionInfo = _$_ClientRegistrationBaseActionController.startAction(
        name: '_ClientRegistrationBase.changeEnabled');
    try {
      return super.changeEnabled(newEnabled);
    } finally {
      _$_ClientRegistrationBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
enabled: ${enabled},
error: ${error},
success: ${success}
    ''';
  }
}
