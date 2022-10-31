import 'package:controle_pedidos/src/modules/provider/errors/provider_error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../establishment/domain/entities/establishment.dart';
import '../../../establishment/domain/services/i_establishment_service.dart';
import '../../../establishment/domain/usecases/i_establishment_usecase.dart';
import '../../../establishment/infra/models/establish_model.dart';
import '../../domain/entities/provider.dart';
import '../../domain/usecases/I_provider_usecase.dart';
import '../../infra/models/provider_model.dart';

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
  Option<ProviderError> error = none();
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

    estabResult.fold((l) => error = optionOf(ProviderError(l.message)), (r) {
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
          .getEstablishmentById(newProviderData.establishmentId);

      result.fold((l) => error = optionOf(ProviderError(l.message)),
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
      loading = true;
      initNewProvider();
      if (newProvider) {
        final create = await providerUsecase.createProvider(newProviderData);

        create.fold((l) => error = optionOf(l), (r) {
          success = optionOf(r);
          Navigator.of(context).pop(r);
        });
      } else {
        final update = await providerUsecase.updateProvider(newProviderData);

        update.fold((l) => error = optionOf(l), (r) {
          success = optionOf(r);
          Navigator.of(context).pop(r);
        });
      }
      loading = false;
    }
  }

  initNewProvider() {
    newProviderData = ProviderModel(
        id: newProvider ? '0' : newProviderData.id,
        name: nameController.text,
        location: locationController.text,
        registrationDate:
            newProvider ? DateTime.now() : newProviderData.registrationDate,
        enabled: enabled,
        establishmentId: selectedEstablishment?.id ?? '',
        establishmentName: selectedEstablishment?.name ?? '');
  }
}
