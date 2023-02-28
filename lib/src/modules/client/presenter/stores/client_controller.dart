import 'package:controle_pedidos/src/modules/client/domain/usecases/i_client_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/admob/services/ad_service.dart';
import '../../../../domain/entities/client.dart';
import '../../errors/client_info_exception.dart';
import '../pages/i_client_registration_page.dart';

part 'client_controller.g.dart';

class ClientController = _ClientListBase with _$ClientController;

abstract class _ClientListBase with Store {
  final IClientUsecase clientUsecase;
  final AdService adService;

  _ClientListBase(this.clientUsecase, this.adService);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  var clientList = ObservableList<Client>.of([]);
  @observable
  var filteredClientList = ObservableList<Client>.of([]);
  @observable
  Option<ClientInfoException> error = none();

  final searchFocus = FocusNode();

  @action
  initState() async {
    resetActionsVars();
    await getClientList();
  }

  @action
  resetActionsVars() {
    loading = false;
    searching = false;
    searchText = '';
    clientList = ObservableList<Client>.of([]);
    filteredClientList = ObservableList<Client>.of([]);
    error = none();
  }

  @action
  getClientList() async {
    loading = true;
    final result = await clientUsecase.getClientList();

    result.fold(
      (l) => error = optionOf(l),
      (r) {
        clientList = ObservableList.of(r);
        filteredClientList = ObservableList.of(r);
      },
    );

    loading = false;
  }

  @action
  filterClientByText() {
    searching = true;
    searchText.toLowerCase();

    filteredClientList.clear();
    List<Client> auxList = [];

    for (var c in clientList) {
      if (c.name.toLowerCase().contains(searchText) ||
          c.email.toLowerCase().contains(searchText) ||
          c.phone.toLowerCase().contains(searchText)) {
        auxList.add(c);
      }
    }
    filteredClientList = ObservableList.of(auxList);
  }

  @action
  clientRegistrationPage(
      {required BuildContext context,
      required IClientRegistrationPage registrationPage}) async {
    searching = false;
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => registrationPage));

    if (result != null) {
      await initState();
    }
  }

  bool showBannerAd() => adService.showBannerAd();

  
}
