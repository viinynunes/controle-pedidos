// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClientController on _ClientListBase, Store {
  late final _$searchTextAtom =
      Atom(name: '_ClientListBase.searchText', context: context);

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
      Atom(name: '_ClientListBase.searching', context: context);

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
      Atom(name: '_ClientListBase.loading', context: context);

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

  late final _$clientListAtom =
      Atom(name: '_ClientListBase.clientList', context: context);

  @override
  ObservableList<Client> get clientList {
    _$clientListAtom.reportRead();
    return super.clientList;
  }

  @override
  set clientList(ObservableList<Client> value) {
    _$clientListAtom.reportWrite(value, super.clientList, () {
      super.clientList = value;
    });
  }

  late final _$filteredClientListAtom =
      Atom(name: '_ClientListBase.filteredClientList', context: context);

  @override
  ObservableList<Client> get filteredClientList {
    _$filteredClientListAtom.reportRead();
    return super.filteredClientList;
  }

  @override
  set filteredClientList(ObservableList<Client> value) {
    _$filteredClientListAtom.reportWrite(value, super.filteredClientList, () {
      super.filteredClientList = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_ClientListBase.error', context: context);

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

  late final _$initStateAsyncAction =
      AsyncAction('_ClientListBase.initState', context: context);

  @override
  Future initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$getClientListAsyncAction =
      AsyncAction('_ClientListBase.getClientList', context: context);

  @override
  Future getClientList() {
    return _$getClientListAsyncAction.run(() => super.getClientList());
  }

  late final _$clientRegistrationPageAsyncAction =
      AsyncAction('_ClientListBase.clientRegistrationPage', context: context);

  @override
  Future clientRegistrationPage(
      {required BuildContext context,
      required IClientRegistrationPage registrationPage}) {
    return _$clientRegistrationPageAsyncAction.run(() => super
        .clientRegistrationPage(
            context: context, registrationPage: registrationPage));
  }

  late final _$_ClientListBaseActionController =
      ActionController(name: '_ClientListBase', context: context);

  @override
  dynamic filterClientByText() {
    final _$actionInfo = _$_ClientListBaseActionController.startAction(
        name: '_ClientListBase.filterClientByText');
    try {
      return super.filterClientByText();
    } finally {
      _$_ClientListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
searching: ${searching},
loading: ${loading},
clientList: ${clientList},
filteredClientList: ${filteredClientList},
error: ${error}
    ''';
  }
}
