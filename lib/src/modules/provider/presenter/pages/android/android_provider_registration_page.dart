import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/show_entity_selection_dialog.dart';
import '../../../../../domain/entities/establishment.dart';
import '../../stores/provider_registration_controller.dart';
import '../i_provider_registration_page.dart';

class AndroidProviderRegistrationPage extends IProviderRegistrationPage {
  const AndroidProviderRegistrationPage({super.key, super.provider});

  @override
  State<StatefulWidget> createState() =>
      _AndroidProviderRegistrationPageState();
}

class _AndroidProviderRegistrationPageState
    extends IProviderRegistrationPageState<AndroidProviderRegistrationPage,
        ProviderRegistrationController> {
  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    reaction((_) => controller.success, (_) {
      controller.success
          .map((_) => showSuccess(message: 'Fornecedor salvo com sucesso'));
    });

    controller.initState(widget.provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.newProvider
            ? 'Novo Fornecedor'
            : controller.nameController.text),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: controller.clearFields,
              icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.saveOrUpdate(context),
        child: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: controller.nameController,
                      focus: controller.nameFocus,
                      label: 'Nome',
                      validator: controller.nameValidator,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      controller: controller.locationController,
                      label: 'Localização',
                      validator: controller.locationValidator,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Estabelecimento'),
                    Observer(
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final selected = await showDialog(
                                context: context,
                                builder: (_) => ShowEntitySelectionDialog(
                                      entityList: controller.establishmentList,
                                    ));

                            if (selected is Establishment) {
                              controller.selectEstablishment(selected);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                controller.selectedEstablishment?.name ?? '',
                              ),
                              const Icon(Icons.search)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text('Ativo'),
                    Observer(
                      builder: (_) => Switch(
                          value: controller.enabled,
                          onChanged: (_) => controller.changeEnabled()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
