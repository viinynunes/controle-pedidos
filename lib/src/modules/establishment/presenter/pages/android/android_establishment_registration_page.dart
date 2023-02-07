import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/widgets/custom_material_banner_error.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../stores/establishment_registration_controller.dart';
import '../i_establishment_registration_page.dart';

class AndroidEstablishmentRegistrationPage
    extends IEstablishmentRegistrationPage {
  const AndroidEstablishmentRegistrationPage({super.key, super.establishment});

  @override
  State<StatefulWidget> createState() =>
      _AndroidEstablishmentRegistrationPageState();
}

class _AndroidEstablishmentRegistrationPageState
    extends IEstablishmentRegistrationPageState {
  final controller = GetIt.I.get<EstablishmentRegistrationController>();

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) =>
          CustomMaterialBannerError.showMaterialBannerError(
              context: context, message: error.message, onClose: () {}));
    });

    reaction((_) => controller.success, (_) {
      controller.success.map((_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estabelecimento salvo com sucesso'))));
    });

    controller.initState(widget.establishment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.establishment == null
            ? 'Novo Estabelecimento'
            : controller.nameController.text),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.clearFields(),
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.saveOrUpdate(context),
        child: const Icon(Icons.save),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                    controller: controller.nameController,
                    focus: controller.nameFocus,
                    label: 'Nome',
                    validator: controller.nameValidator),
                const SizedBox(
                  height: 20,
                ),
                const Text('Ativo'),
                Observer(
                    builder: (_) => Switch(
                        value: controller.enabled,
                        onChanged: controller.changeEnabled)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}