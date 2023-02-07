// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProviderController on _ProviderControllerBase, Store {
  late final _$searchTextAtom =
      Atom(name: '_ProviderControllerBase.searchText', context: context);

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  late final _$searchingAtom =
      Atom(name: '_ProviderControllerBase.searching', context: context);

  @override
  bool get searching {
    _$searchingAtom.reportRead();
    return super.searching;
  }

  @override
  set searching(bool value) {
    _$searchingAtom.reportWrite(value, super.searching, () {
      super.searching = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_ProviderControllerBase.loading', context: context);

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

  late final _$providerListAtom =
      Atom(name: '_ProviderControllerBase.providerList', context: context);

  @override
  ObservableList<Provider> get providerList {
    _$providerListAtom.reportRead();
    return super.providerList;
  }

  @override
  set providerList(ObservableList<Provider> value) {
    _$providerListAtom.reportWrite(value, super.providerList, () {
      super.providerList = value;
    });
  }

  late final _$filteredProviderListAtom = Atom(
      name: '_ProviderControllerBase.filteredProviderList', context: context);

  @override
  ObservableList<Provider> get filteredProviderList {
    _$filteredProviderListAtom.reportRead();
    return super.filteredProviderList;
  }

  @override
  set filteredProviderList(ObservableList<Provider> value) {
    _$filteredProviderListAtom.reportWrite(value, super.filteredProviderList,
        () {
      super.filteredProviderList = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_ProviderControllerBase.error', context: context);

  @override
  Option<ProviderError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<ProviderError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$initStateAsyncAction =
      AsyncAction('_ProviderControllerBase.initState', context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$getProviderListAsyncAction =
      AsyncAction('_ProviderControllerBase.getProviderList', context: context);

  @override
  Future getProviderList() {
    return _$getProviderListAsyncAction.run(() => super.getProviderList());
  }

  late final _$callProviderRegistrationPageAsyncAction = AsyncAction(
      '_ProviderControllerBase.callProviderRegistrationPage',
      context: context);

  @override
  Future callProviderRegistrationPage(
      {required BuildContext context,
      required IProviderRegistrationPage registrationPage}) {
    return _$callProviderRegistrationPageAsyncAction.run(() => super
        .callProviderRegistrationPage(
            context: context, registrationPage: registrationPage));
  }

  late final _$_ProviderControllerBaseActionController =
      ActionController(name: '_ProviderControllerBase', context: context);

  @override
  dynamic resetActionsVars() {
    final _$actionInfo = _$_ProviderControllerBaseActionController.startAction(
        name: '_ProviderControllerBase.resetActionsVars');
    try {
      return super.resetActionsVars();
    } finally {
      _$_ProviderControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic filterProviderListByText() {
    final _$actionInfo = _$_ProviderControllerBaseActionController.startAction(
        name: '_ProviderControllerBase.filterProviderListByText');
    try {
      return super.filterProviderListByText();
    } finally {
      _$_ProviderControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
searching: ${searching},
loading: ${loading},
providerList: ${providerList},
filteredProviderList: ${filteredProviderList},
error: ${error}
    ''';
  }
}
