import 'package:controle_pedidos/src/modules/client/domain/entities/client.dart';
import 'package:controle_pedidos/src/modules/client/presenter/stores/client_registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/custom_text_form_field.dart';

class AndroidClientRegistrationPage extends StatefulWidget {
  const AndroidClientRegistrationPage({Key? key, required this.client})
      : super(key: key);

  final Client? client;

  @override
  State<AndroidClientRegistrationPage> createState() =>
      _AndroidClientRegistrationPageState();
}

class _AndroidClientRegistrationPageState
    extends State<AndroidClientRegistrationPage> {
  final controller = GetIt.I.get<ClientRegistrationController>();

  @override
  void initState() {
    super.initState();

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
        onPressed: () {
          if (controller.formKey.currentState!.validate()) {
            controller.initNewClient();
            Navigator.pop(context, controller.newClientData);
          }
        },
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                      controller: controller.nameController,
                      focus: controller.focusName,
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
