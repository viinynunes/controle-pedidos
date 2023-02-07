// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_details_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CompanyDetailsController on _CompanyDetailsControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_CompanyDetailsControllerBase.loading', context: context);

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

  late final _$userAtom =
      Atom(name: '_CompanyDetailsControllerBase.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$getLoggedUserAsyncAction = AsyncAction(
      '_CompanyDetailsControllerBase.getLoggedUser',
      context: context);

  @override
  Future getLoggedUser() {
    return _$getLoggedUserAsyncAction.run(() => super.getLoggedUser());
  }

  late final _$logoutAsyncAction =
      AsyncAction('_CompanyDetailsControllerBase.logout', context: context);

  @override
  Future logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
loading: ${loading},
user: ${user}
    ''';
  }
}
