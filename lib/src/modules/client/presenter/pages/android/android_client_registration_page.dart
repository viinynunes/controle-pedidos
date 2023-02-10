import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../stores/client_registration_controller.dart';
import '../i_client_registration_page.dart';

class AndroidClientRegistrationPage extends IClientRegistrationPage {
  const AndroidClientRegistrationPage({super.key, super.client});

  @override
  State<AndroidClientRegistrationPage> createState() =>
      _AndroidClientRegistrationPageState();
}

class _AndroidClientRegistrationPageState extends IClientRegistrationPageState<
    AndroidClientRegistrationPage, ClientRegistrationController> {
  @override
  void initState() {
    super.initState();

    reaction((p0) => controller.error, (p0) {
      controller.error.map((error) => showError(message: error.message));
    });

    reaction((_) => controller.success, (_) {
      controller.success
          .map((error) => showSuccess(message: 'Cliente salvo com sucesso'));
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
                    textInputType: TextInputType.emailAddress,
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
