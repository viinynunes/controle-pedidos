import 'package:controle_pedidos/src/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/usecases/i_establishment_usecase.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_info_exception.dart';
import 'package:controle_pedidos/src/modules/establishment/presenter/pages/i_establishment_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/admob/services/ad_service.dart';

part 'establishment_controller.g.dart';

class EstablishmentController = _EstablishmentControllerBase
    with _$EstablishmentController;

abstract class _EstablishmentControllerBase with Store {
  final IEstablishmentUsecase usecase;
  final AdService adService;

  _EstablishmentControllerBase(this.usecase, this.adService);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  Option<EstablishmentInfoException> error = none();
  @observable
  var estabList = ObservableList<Establishment>.of([]);
  @observable
  var filteredEstabList = ObservableList<Establishment>.of([]);

  final searchFocus = FocusNode();

  @action
  initState() {
    resetActionsVars();
    getEstablishmentList();
  }

  @action
  resetActionsVars() {
    loading = false;
    searching = false;
    searchText = '';
    estabList = ObservableList<Establishment>.of([]);
    filteredEstabList = ObservableList<Establishment>.of([]);
    error = none();
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
      {required BuildContext context,
      required IEstablishmentRegistrationPage registrationPage}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => registrationPage,
      ),
    );

    if (result != null) {
      loading = true;
      await Future.delayed(const Duration(seconds: 1));

      await getEstablishmentList();
    }

    initState();
  }

  bool showBannerAd() => adService.showBannerAd();
}
