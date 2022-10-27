import 'package:controle_pedidos/src/modules/client/domain/usecases/i_client_usecase.dart';
import 'package:controle_pedidos/src/modules/client/presenter/android/pages/android_client_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../domain/entities/client.dart';
import '../../errors/client_errors.dart';

part 'client_controller.g.dart';

class ClientController = _ClientListBase with _$ClientController;

abstract class _ClientListBase with Store {
  final IClientUsecase clientUsecase;

  _ClientListBase(this.clientUsecase);

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
  Option<ClientError> error = none();

  final searchFocus = FocusNode();

  @action
  initState() {
    getClientList();
  }

  @action
  createClient(Client client) async {
    loading = true;
    error = none();
    final result = await clientUsecase.createClient(client);

    result.fold(
      (l) => {error = optionOf(l)},
      (r) => getClientList(),
    );

    loading = false;
  }

  @action
  getClientList() async {
    loading = true;
    error = none();
    final result = await clientUsecase.getClientList();

    result.fold(
      (l) => error = optionOf(l),
      (r) => clientList = ObservableList.of(r),
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
  clientRegistrationPage(BuildContext context, Client? client) async {
    loading = true;
    error = none();
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AndroidClientRegistrationPage(client: client)));

    if (result != null && result is Client) {
      if (client == null) {
        final create = await clientUsecase.createClient(result);

        create.fold((l) => error = optionOf(l), (r) => getClientList());
      } else {
        final update = await clientUsecase.updateClient(result);

        update.fold((l) => error = optionOf(l), (r) => getClientList());
      }
    }
    loading = false;
  }
}
