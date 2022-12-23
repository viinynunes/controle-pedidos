// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_entity_selection_dialog_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ShowEntitySelectionDialogController
    on _ShowEntitySelectionDialogControllerBase, Store {
  late final _$searchTextAtom = Atom(
      name: '_ShowEntitySelectionDialogControllerBase.searchText',
      context: context);

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

  late final _$searchingAtom = Atom(
      name: '_ShowEntitySelectionDialogControllerBase.searching',
      context: context);

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

  late final _$errorAtom = Atom(
      name: '_ShowEntitySelectionDialogControllerBase.error', context: context);

  @override
  Option<ShowEntitySelectionDialogError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<ShowEntitySelectionDialogError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$filteredObjectListAtom = Atom(
      name: '_ShowEntitySelectionDialogControllerBase.filteredObjectList',
      context: context);

  @override
  ObservableList<dynamic> get filteredObjectList {
    _$filteredObjectListAtom.reportRead();
    return super.filteredObjectList;
  }

  @override
  set filteredObjectList(ObservableList<dynamic> value) {
    _$filteredObjectListAtom.reportWrite(value, super.filteredObjectList, () {
      super.filteredObjectList = value;
    });
  }

  late final _$_ShowEntitySelectionDialogControllerBaseActionController =
      ActionController(
          name: '_ShowEntitySelectionDialogControllerBase', context: context);

  @override
  dynamic initState(List<dynamic> entityList) {
    final _$actionInfo =
        _$_ShowEntitySelectionDialogControllerBaseActionController.startAction(
            name: '_ShowEntitySelectionDialogControllerBase.initState');
    try {
      return super.initState(entityList);
    } finally {
      _$_ShowEntitySelectionDialogControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic filterEntityList() {
    final _$actionInfo =
        _$_ShowEntitySelectionDialogControllerBaseActionController.startAction(
            name: '_ShowEntitySelectionDialogControllerBase.filterEntityList');
    try {
      return super.filterEntityList();
    } finally {
      _$_ShowEntitySelectionDialogControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
searching: ${searching},
error: ${error},
filteredObjectList: ${filteredObjectList}
    ''';
  }
}
