import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/models/establish_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'establishment_registration_controller.g.dart';

class EstablishmentRegistrationController = _EstablishmentRegistrationControllerBase
    with _$EstablishmentRegistrationController;

abstract class _EstablishmentRegistrationControllerBase with Store {
  @observable
  bool enabled = true;
  @observable
  bool newEstablishment = true;

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

  String? nameValidator(String? text) {
    if (text!.isEmpty || text.length < 2) {
      return 'Nome inválido';
    }

    return null;
  }
}
