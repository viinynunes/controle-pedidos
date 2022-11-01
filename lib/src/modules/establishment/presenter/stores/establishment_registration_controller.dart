import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/usecases/i_establishment_usecase.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/models/establish_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../errors/establishment_errors.dart';

part 'establishment_registration_controller.g.dart';

class EstablishmentRegistrationController = _EstablishmentRegistrationControllerBase
    with _$EstablishmentRegistrationController;

abstract class _EstablishmentRegistrationControllerBase with Store {
  final IEstablishmentUsecase usecase;

  _EstablishmentRegistrationControllerBase(this.usecase);

  @observable
  bool enabled = true;
  @observable
  bool newEstablishment = true;
  @observable
  Option<bool> success = none();
  @observable
  Option<EstablishmentError> error = none();

  final nameController = TextEditingController();
  late EstablishmentModel newEstablishmentData;

  final formKey = GlobalKey<FormState>();
  final nameFocus = FocusNode();

  @action
  initState(Establishment? establishment) {
    if (establishment != null) {
      newEstablishment = false;
      newEstablishmentData =
          EstablishmentModel.fromEstablishment(establishment: establishment);
      nameController.text = newEstablishmentData.name;
      enabled = newEstablishmentData.enabled;
    }

    nameFocus.requestFocus();
  }

  @action
  changeEnabled(value) {
    enabled = !enabled;
  }

  clearFields() {
    nameController.text = '';
  }

  initNewEstablishment() {
    newEstablishmentData = EstablishmentModel(
        id: newEstablishment ? '0' : newEstablishmentData.id,
        name: nameController.text,
        registrationDate: DateTime.now(),
        enabled: enabled);
  }

  saveOrUpdate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      initNewEstablishment();

      if (newEstablishment) {
        final create = await usecase.createEstablishment(newEstablishmentData);

        create.fold((l) => error = optionOf(l), (r) {
          success = optionOf(true);
          Navigator.of(context).pop(r);
        });
      } else {
        final update = await usecase.updateEstablishment(newEstablishmentData);

        update.fold((l) => error = optionOf(l), (r) {
          success = optionOf(true);
          Navigator.of(context).pop(r);
        });
      }
    }
  }

  String? nameValidator(String? text) {
    if (text!.isEmpty || text.length < 2) {
      return 'Nome inválido';
    }

    return null;
  }
}
