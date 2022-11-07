import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/client/presenter/pages/android/android_client_registration_page.dart';
import 'package:controle_pedidos/src/modules/product/presenter/pages/android/pages/android_product_registration_page.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/pages/android/android_provider_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/provider.dart';
import '../../../establishment/presenter/pages/android/android_establishment_registration_page.dart';
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

    if (objectList is ObservableList<Product>) {
      result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AndroidProductRegistrationPage()));
    }

    if (objectList is ObservableList<Client>) {
      result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AndroidClientRegistrationPage()));
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

    if (objectList is ObservableList<Product>) {
      auxList = productFilterCondition();
    }

    if (objectList is ObservableList<Client>) {
      auxList = clientFilterCondition();
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

  List<Product> productFilterCondition() {
    List<Product> auxList = [];

    for (Product p in objectList) {
      if (p.name.toLowerCase().contains(searchText) ||
          p.providerName.toLowerCase().contains(searchText) ||
          p.category.toLowerCase().contains(searchText) ||
          p.enabled.toString().toLowerCase().contains(searchText)) {
        auxList.add(p);
      }
    }

    return auxList;
  }

  List<Client> clientFilterCondition() {
    List<Client> auxList = [];

    for (Client c in objectList) {
      if (c.name.toLowerCase().contains(searchText) ||
          c.enabled.toString().toLowerCase().contains(searchText)) {
        auxList.add(c);
      }
    }

    return auxList;
  }
}
