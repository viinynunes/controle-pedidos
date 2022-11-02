import 'package:controle_pedidos/src/modules/client/presenter/pages/i_client_registration_page.dart';
import 'package:controle_pedidos/src/modules/client/presenter/stores/client_registration_controller.dart';
import 'package:controle_pedidos/src/modules/core/widgets/custom_material_banner_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/widgets/custom_text_form_field.dart';

class AndroidClientRegistrationPage extends IClientRegistrationPage {
  const AndroidClientRegistrationPage({super.key, super.client});

  @override
  State<AndroidClientRegistrationPage> createState() =>
      _AndroidClientRegistrationPageState();
}

class _AndroidClientRegistrationPageState
    extends IClientRegistrationPageState<AndroidClientRegistrationPage> {
  final controller = GetIt.I.get<ClientRegistrationController>();

  @override
  void initState() {
    super.initState();

    reaction((p0) => controller.error, (p0) {
      controller.error
          .map((error) => CustomMaterialBannerError.showMaterialBannerError(
              context: context,
              message: error.message,
              onClose: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              }));
    });

    reaction((_) => controller.success, (_) {
      controller.success.map((error) => ScaffoldMessenger.of(context)
          .showSnackBar(
              const SnackBar(content: Text('Cliente salvo com sucesso'))));
    });

    controller.initState(client: widget.client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null
            ? 'Novo Cliente'
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
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
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
                  CustomTextFormField(
                    controller: controller.emailController,
                    label: 'Email',
                    validator: controller.emailValidator,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      controller: controller.phoneController,
                      label: 'Telefone',
                      validator: controller.phoneValidator,
                      textInputType: TextInputType.phone),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      controller: controller.addressController,
                      label: 'Endereço'),
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
      ),
    );
  }
}
