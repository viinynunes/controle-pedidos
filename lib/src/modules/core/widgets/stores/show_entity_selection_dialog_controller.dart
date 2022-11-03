import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/pages/android/android_provider_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../establishment/presenter/pages/android/android_establishment_registration_page.dart';
import '../../../provider/domain/entities/provider.dart';
import '../errors/show_entity_selection_dialog_error.dart';

part 'show_entity_selection_dialog_controller.g.dart';

class ShowEntitySelectionDialogController = _ShowEntitySelectionDialogControllerBase
    with _$ShowEntitySelectionDialogController;

abstract class _ShowEntitySelectionDialogControllerBase with Store {
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  Option<ShowEntitySelectionDialogError> error = none();
  List objectList = [];
  @observable
  var filteredObjectList = ObservableList.of([]);

  @action
  initState(List entityList) {
    objectList = entityList;
    filteredObjectList = ObservableList.of(entityList);

    searchFocus.requestFocus();
  }

  callEntityRegistrationPage(BuildContext context) async {
    Object? result;

    if (objectList is List<Provider>) {
      result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AndroidProviderRegistrationPage()));
    }

    if (objectList is ObservableList<Establishment>) {
      result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AndroidEstablishmentRegistrationPage()));
    }

    if (result != null) {
      objectList.add(result);
      filteredObjectList.add(result);
    }
  }

  @action
  filterEntityList() {
    searchText.toLowerCase();
    filteredObjectList.clear();

    List<Object> auxList = [];

    if (objectList is List<Provider>) {
      auxList = providerFilterCondition();
    }

    if (objectList is ObservableList<Establishment>) {
      auxList = establishmentFilterCondition();
    }

    filteredObjectList = ObservableList.of(auxList);
  }

  List<Establishment> establishmentFilterCondition() {
    List<Establishment> auxList = [];

    for (Establishment e in objectList) {
      if (e.name.toLowerCase().contains(searchText) ||
          e.enabled.toString().toLowerCase().contains(searchText)) {
        auxList.add(e);
      }
    }

    return auxList;
  }

  List<Provider> providerFilterCondition() {
    List<Provider> auxList = [];

    for (Provider p in objectList) {
      if (p.name.toLowerCase().contains(searchText) ||
          p.location.toLowerCase().contains(searchText) ||
          p.enabled.toString().toLowerCase().contains(searchText)) {
        auxList.add(p);
      }
    }

    return auxList;
  }
}
