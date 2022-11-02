import 'package:controle_pedidos/src/modules/client/domain/usecases/i_client_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:string_validator/string_validator.dart';

import '../../domain/entities/client.dart';
import '../../errors/client_errors.dart';
import '../../infra/models/client_model.dart';

part 'client_registration_controller.g.dart';

class ClientRegistrationController = _ClientRegistrationBase
    with _$ClientRegistrationController;

abstract class _ClientRegistrationBase with Store {
  final IClientUsecase usecase;

  _ClientRegistrationBase(this.usecase);

  @observable
  bool enabled = true;
  @observable
  Option<ClientError> error = none();
  @observable
  Option<Client> success = none();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool newClient = true;

  final formKey = GlobalKey<FormState>();
  final nameFocus = FocusNode();

  late ClientModel newClientData;

  initState({Client? client}) {
    if (null != client) {
      newClientData = ClientModel.fromClient(client);
      nameController.text = newClientData.name;
      emailController.text = newClientData.email;
      phoneController.text = newClientData.phone;
      addressController.text = newClientData.address;
      enabled = client.enabled;
      newClient = false;
    }
    nameFocus.requestFocus();
  }

  initNewClient() {
    newClientData = ClientModel(
        id: newClient ? '0' : newClientData.id,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        enabled: enabled);
  }

  @action
  changeEnabled(newEnabled) {
    enabled = !enabled;
  }

  clearFields() {
    nameController.text = '';
    emailController.text = '';
    phoneController.text = '';
    addressController.text = '';
  }

  String? nameValidator(String? text) {
    if (nameController.text.isEmpty) {
      return 'Nome Obrigatório';
    }
    return null;
  }

  String? emailValidator(String? text) {
    if (text!.isNotEmpty && !isEmail(text)) {
      return 'Email Inválido';
    }
    return null;
  }

  String? phoneValidator(String? text) {
    if (text!.isNotEmpty && text.length != 11) {
      return 'Telefone Inválido';
    }
    return null;
  }

  @action
  saveOrUpdate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      initNewClient();
      if (newClient) {
        final create = await usecase.createClient(newClientData);

        create.fold((l) => error = optionOf(l), (r) {
          success = optionOf(r);
          Navigator.of(context).pop(r);
        });
      } else {
        final update = await usecase.updateClient(newClientData);

        update.fold((l) => error = optionOf(l), (r) {
          success = optionOf(r);
          Navigator.of(context).pop(r);
        });
      }
    }
  }
}
