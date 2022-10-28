// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'establishment_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EstablishmentController on _EstablishmentControllerBase, Store {
  late final _$searchTextAtom =
      Atom(name: '_EstablishmentControllerBase.searchText', context: context);

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
      Atom(name: '_EstablishmentControllerBase.searching', context: context);

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
      Atom(name: '_EstablishmentControllerBase.loading', context: context);

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

  late final _$errorAtom =
      Atom(name: '_EstablishmentControllerBase.error', context: context);

  @override
  Option<EstablishmentError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<EstablishmentError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$estabListAtom =
      Atom(name: '_EstablishmentControllerBase.estabList', context: context);

  @override
  ObservableList<Establishment> get estabList {
    _$estabListAtom.reportRead();
    return super.estabList;
  }

  @override
  set estabList(ObservableList<Establishment> value) {
    _$estabListAtom.reportWrite(value, super.estabList, () {
      super.estabList = value;
    });
  }

  late final _$filteredEstabListAtom = Atom(
      name: '_EstablishmentControllerBase.filteredEstabList', context: context);

  @override
  ObservableList<Establishment> get filteredEstabList {
    _$filteredEstabListAtom.reportRead();
    return super.filteredEstabList;
  }

  @override
  set filteredEstabList(ObservableList<Establishment> value) {
    _$filteredEstabListAtom.reportWrite(value, super.filteredEstabList, () {
      super.filteredEstabList = value;
    });
  }

  late final _$getEstablishmentListAsyncAction = AsyncAction(
      '_EstablishmentControllerBase.getEstablishmentList',
      context: context);

  @override
  Future getEstablishmentList() {
    return _$getEstablishmentListAsyncAction
        .run(() => super.getEstablishmentList());
  }

  late final _$callEstablishmentRegistrationPageAsyncAction = AsyncAction(
      '_EstablishmentControllerBase.callEstablishmentRegistrationPage',
      context: context);

  @override
  Future callEstablishmentRegistrationPage(
      {required BuildContext context, Establishment? establishment}) {
    return _$callEstablishmentRegistrationPageAsyncAction.run(() => super
        .callEstablishmentRegistrationPage(
            context: context, establishment: establishment));
  }

  late final _$_EstablishmentControllerBaseActionController =
      ActionController(name: '_EstablishmentControllerBase', context: context);

  @override
  dynamic initState() {
    final _$actionInfo = _$_EstablishmentControllerBaseActionController
        .startAction(name: '_EstablishmentControllerBase.initState');
    try {
      return super.initState();
    } finally {
      _$_EstablishmentControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic filterEstablishmentListByText() {
    final _$actionInfo =
        _$_EstablishmentControllerBaseActionController.startAction(
            name: '_EstablishmentControllerBase.filterEstablishmentListByText');
    try {
      return super.filterEstablishmentListByText();
    } finally {
      _$_EstablishmentControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
searching: ${searching},
loading: ${loading},
error: ${error},
estabList: ${estabList},
filteredEstabList: ${filteredEstabList}
    ''';
  }
}
