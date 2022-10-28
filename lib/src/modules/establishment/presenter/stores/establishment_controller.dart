import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/usecases/i_establishment_usecase.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_errors.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../android/pages/android_establishment_registration_page.dart';

part 'establishment_controller.g.dart';

class EstablishmentController = _EstablishmentControllerBase
    with _$EstablishmentController;

abstract class _EstablishmentControllerBase with Store {
  final IEstablishmentUsecase usecase;

  _EstablishmentControllerBase(this.usecase);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  Option<EstablishmentError> error = none();
  @observable
  var estabList = ObservableList<Establishment>.of([]);
  @observable
  var filteredEstabList = ObservableList<Establishment>.of([]);

  final searchFocus = FocusNode();

  @action
  initState() {
    getEstablishmentList();
  }

  @action
  getEstablishmentList() async {
    loading = true;
    final result = await usecase.getEstablishmentList();

    result.fold(
        (l) => error = optionOf(l), (r) => estabList = ObservableList.of(r));

    loading = false;
  }

  @action
  filterEstablishmentListByText() {
    searching = true;
    searchText.toLowerCase();

    filteredEstabList.clear();
    List<Establishment> auxList = [];

    for (var e in estabList) {
      if (e.name.toLowerCase().contains(searchText)) {
        auxList.add(e);
      }
    }

    filteredEstabList = ObservableList.of(auxList);
  }

  @action
  callEstablishmentRegistrationPage(
      {required BuildContext context, Establishment? establishment}) async {
    final newEstab = await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AndroidEstablishmentRegistrationPage(
            establishment: establishment)));

    loading = true;

    if (newEstab != null && newEstab is Establishment) {
      if (establishment == null) {
        final create = await usecase.createEstablishment(newEstab);

        create.fold((l) => error = optionOf(l), (r) => getEstablishmentList());
      } else {
        final update = await usecase.updateEstablishment(newEstab);

        update.fold((l) => error = optionOf(l), (r) => getEstablishmentList());
      }
    }

    loading = false;
  }
}
