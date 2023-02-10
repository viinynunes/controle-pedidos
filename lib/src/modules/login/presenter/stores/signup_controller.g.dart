// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignupController on _SignupControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_SignupControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$showCompanyFieldsAtom =
      Atom(name: '_SignupControllerBase.showCompanyFields', context: context);

  @override
  bool get showCompanyFields {
    _$showCompanyFieldsAtom.reportRead();
    return super.showCompanyFields;
  }

  @override
  set showCompanyFields(bool value) {
    _$showCompanyFieldsAtom.reportWrite(value, super.showCompanyFields, () {
      super.showCompanyFields = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_SignupControllerBase.error', context: context);

  @override
  Option<LoginInfoException> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<LoginInfoException> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$signupAsyncAction =
      AsyncAction('_SignupControllerBase.signup', context: context);

  @override
  Future signup({required VoidCallback onSignupSucceffuly}) {
    return _$signupAsyncAction
        .run(() => super.signup(onSignupSucceffuly: onSignupSucceffuly));
  }

  late final _$_SignupControllerBaseActionController =
      ActionController(name: '_SignupControllerBase', context: context);

  @override
  dynamic toggleShowCompanyFields() {
    final _$actionInfo = _$_SignupControllerBaseActionController.startAction(
        name: '_SignupControllerBase.toggleShowCompanyFields');
    try {
      return super.toggleShowCompanyFields();
    } finally {
      _$_SignupControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
showCompanyFields: ${showCompanyFields},
error: ${error}
    ''';
  }
}
