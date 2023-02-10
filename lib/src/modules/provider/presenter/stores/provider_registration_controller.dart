import 'package:controle_pedidos/src/modules/provider/errors/provider_info_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/establishment.dart';
import '../../../../domain/entities/provider.dart';
import '../../../../domain/models/establish_model.dart';
import '../../../../domain/models/provider_model.dart';
import '../../../establishment/domain/services/i_establishment_service.dart';
import '../../../establishment/domain/usecases/i_establishment_usecase.dart';
import '../../domain/usecases/i_provider_usecase.dart';

part 'provider_registration_controller.g.dart';

class ProviderRegistrationController = _ProviderRegistrationControllerBase
    with _$ProviderRegistrationController;

abstract class _ProviderRegistrationControllerBase with Store {
  final IProviderUsecase providerUsecase;
  final IEstablishmentUsecase establishmentUsecase;
  final IEstablishmentService establishmentService;

  _ProviderRegistrationControllerBase(this.providerUsecase,
      this.establishmentUsecase, this.establishmentService);

  @observable
  bool loading = false;
  @observable
  bool newProvider = true;
  @observable
  bool enabled = true;
  @observable
  var establishmentList = ObservableList<Establishment>.of([]);
  @observable
  Option<ProviderInfoException> error = none();
  @observable
  Option<bool> success = none();

  @observable
  Establishment? selectedEstablishment;
  late ProviderModel newProviderData;

  final nameController = TextEditingController();
  final locationController = TextEditingController();

  final nameFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  @action
  initState(Provider? provider) async {
    loading = true;
    if (provider != null) {
      newProvider = false;
      newProviderData = ProviderModel.fromProvider(provider);
      nameController.text = newProviderData.name;
      locationController.text = newProviderData.location;
      enabled = newProviderData.enabled;
    }

    nameFocus.requestFocus();
    await getEstablishmentByEnabled();
    await getEstablishmentFromProvider();
    loading = false;
  }

  @action
  getEstablishmentByEnabled() async {
    loading = true;
    final estabResult = await establishmentUsecase.getEstablishmentList();

    estabResult.fold((l) => error = optionOf(ProviderInfoException(l.message)), (r) {
      establishmentList = ObservableList.of(r);
      establishmentService
          .sortEstablishmentListByRegistrationDate(establishmentList);
    });

    loading = false;
  }

  @action
  getEstablishmentFromProvider() async {
    if (!newProvider) {
      loading = true;
      final result = await establishmentUsecase
          .getEstablishmentById(newProviderData.establishment.id);

      result.fold((l) => error = optionOf(ProviderInfoException(l.message)),
          (r) => selectedEstablishment = r);
    } else {
      selectedEstablishment = establishmentList.first;
    }

    loading = false;
  }

  @action
  changeEnabled() {
    enabled = !enabled;
  }

  @action
  selectEstablishment(Establishment establishment) {
    selectedEstablishment =
        EstablishmentModel.fromEstablishment(establishment: establishment);
  }

  clearFields() {
    nameController.text = '';
    locationController.text = '';
  }

  String? nameValidator(String? text) {
    if (text!.isEmpty) {
      return 'Nome Inválido';
    }

    return null;
  }

  String? locationValidator(String? text) {
    if (text!.isEmpty) {
      return 'Nome Inválido';
    }

    return null;
  }

  @action
  saveOrUpdate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (selectedEstablishment == null) {
        error = optionOf(ProviderInfoException('O Estabelecimento deve ser selecionado'));
        return;
      }

      loading = true;
      initNewProvider();
      if (newProvider) {
        final create = await providerUsecase.createProvider(newProviderData);

        create.fold((l) => error = optionOf(l), (r) {
          success = optionOf(true);
          Navigator.of(context).pop(r);
        });
      } else {
        final update = await providerUsecase.updateProvider(newProviderData);

        update.fold((l) => error = optionOf(l), (r) {
          success = optionOf(true);
          Navigator.of(context).pop(r);
        });
      }
      loading = false;
    }
  }

  initNewProvider() {
    if (selectedEstablishment != null) {
      return newProviderData = ProviderModel(
          id: newProvider ? '0' : newProviderData.id,
          name: nameController.text,
          location: locationController.text,
          registrationDate:
              newProvider ? DateTime.now() : newProviderData.registrationDate,
          enabled: enabled,
          establishment: selectedEstablishment!);
    }
  }
}
