// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomePageController on _HomePageControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_HomePageControllerBase.loading', context: context);

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

  late final _$bottomNavigationIndexAtom = Atom(
      name: '_HomePageControllerBase.bottomNavigationIndex', context: context);

  @override
  int get bottomNavigationIndex {
    _$bottomNavigationIndexAtom.reportRead();
    return super.bottomNavigationIndex;
  }

  @override
  set bottomNavigationIndex(int value) {
    _$bottomNavigationIndexAtom.reportWrite(value, super.bottomNavigationIndex,
        () {
      super.bottomNavigationIndex = value;
    });
  }

  late final _$productErrorAtom =
      Atom(name: '_HomePageControllerBase.productError', context: context);

  @override
  Option<ProductError> get productError {
    _$productErrorAtom.reportRead();
    return super.productError;
  }

  @override
  set productError(Option<ProductError> value) {
    _$productErrorAtom.reportWrite(value, super.productError, () {
      super.productError = value;
    });
  }

  late final _$clientErrorAtom =
      Atom(name: '_HomePageControllerBase.clientError', context: context);

  @override
  Option<ClientError> get clientError {
    _$clientErrorAtom.reportRead();
    return super.clientError;
  }

  @override
  set clientError(Option<ClientError> value) {
    _$clientErrorAtom.reportWrite(value, super.clientError, () {
      super.clientError = value;
    });
  }

  late final _$initStateAsyncAction =
      AsyncAction('_HomePageControllerBase.initState', context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$getProductListByEnabledAsyncAction = AsyncAction(
      '_HomePageControllerBase.getProductListByEnabled',
      context: context);

  @override
  Future getProductListByEnabled() {
    return _$getProductListByEnabledAsyncAction
        .run(() => super.getProductListByEnabled());
  }

  late final _$getClientListByEnabledAsyncAction = AsyncAction(
      '_HomePageControllerBase.getClientListByEnabled',
      context: context);

  @override
  Future getClientListByEnabled() {
    return _$getClientListByEnabledAsyncAction
        .run(() => super.getClientListByEnabled());
  }

  late final _$_HomePageControllerBaseActionController =
      ActionController(name: '_HomePageControllerBase', context: context);

  @override
  dynamic changeIndex(int index) {
    final _$actionInfo = _$_HomePageControllerBaseActionController.startAction(
        name: '_HomePageControllerBase.changeIndex');
    try {
      return super.changeIndex(index);
    } finally {
      _$_HomePageControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
bottomNavigationIndex: ${bottomNavigationIndex},
productError: ${productError},
clientError: ${clientError}
    ''';
  }
}
