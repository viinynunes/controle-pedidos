import 'package:controle_pedidos/src/modules/provider/domain/usecases/I_provider_usecase.dart';
import 'package:controle_pedidos/src/modules/provider/errors/provider_error.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/android/pages/android_provider_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../domain/entities/provider.dart';

part 'provider_controller.g.dart';

class ProviderController = _ProviderControllerBase with _$ProviderController;

abstract class _ProviderControllerBase with Store {
  final IProviderUsecase usecase;

  _ProviderControllerBase(this.usecase);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  var providerList = ObservableList<Provider>.of([]);
  @observable
  var filteredProviderList = ObservableList<Provider>.of([]);
  @observable
  Option<ProviderError> error = none();

  final searchFocus = FocusNode();

  @action
  initState() {
    getProviderList();
  }

  @action
  getProviderList() async {
    loading = true;
    final result = await usecase.getProviderList();

    result.fold(
        (l) => error = optionOf(l), (r) => providerList = ObservableList.of(r));
    loading = false;
  }

  @action
  filterProviderListByText() {
    searchText.toLowerCase();
    filteredProviderList.clear();

    List<Provider> auxList = [];

    for (var p in providerList) {
      if (p.name.toLowerCase().contains(searchText) ||
          p.location.toLowerCase().contains(searchText) ||
          p.establishmentName.toLowerCase().contains(searchText)) {
        auxList.add(p);
      }
    }

    filteredProviderList = ObservableList.of(auxList);
  }

  callProviderRegistrationPage({
    required BuildContext context,
    Provider? provider,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AndroidProviderRegistrationPage(
          provider: provider,
        ),
      ),
    );

    initState();
  }
}
