// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on _LoginControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_LoginControllerBase.loading', context: context);

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

  late final _$passwordResetEmailSentSucceffulyAtom = Atom(
      name: '_LoginControllerBase.passwordResetEmailSentSucceffuly',
      context: context);

  @override
  bool get passwordResetEmailSentSucceffuly {
    _$passwordResetEmailSentSucceffulyAtom.reportRead();
    return super.passwordResetEmailSentSucceffuly;
  }

  @override
  set passwordResetEmailSentSucceffuly(bool value) {
    _$passwordResetEmailSentSucceffulyAtom
        .reportWrite(value, super.passwordResetEmailSentSucceffuly, () {
      super.passwordResetEmailSentSucceffuly = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_LoginControllerBase.error', context: context);

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

  late final _$sendPasswordResetEmailAsyncAction = AsyncAction(
      '_LoginControllerBase.sendPasswordResetEmail',
      context: context);

  @override
  Future<String> sendPasswordResetEmail() {
    return _$sendPasswordResetEmailAsyncAction
        .run(() => super.sendPasswordResetEmail());
  }

  late final _$_LoginControllerBaseActionController =
      ActionController(name: '_LoginControllerBase', context: context);

  @override
  dynamic initState() {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.initState');
    try {
      return super.initState();
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
passwordResetEmailSentSucceffuly: ${passwordResetEmailSentSucceffuly},
error: ${error}
    ''';
  }
}
