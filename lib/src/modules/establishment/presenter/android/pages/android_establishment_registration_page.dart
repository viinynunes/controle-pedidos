import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/presenter/stores/establishment_registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/custom_text_form_field.dart';

class AndroidEstablishmentRegistrationPage extends StatefulWidget {
  const AndroidEstablishmentRegistrationPage({Key? key, this.establishment})
      : super(key: key);

  final Establishment? establishment;

  @override
  State<AndroidEstablishmentRegistrationPage> createState() =>
      _AndroidEstablishmentRegistrationPageState();
}

class _AndroidEstablishmentRegistrationPageState
    extends State<AndroidEstablishmentRegistrationPage> {
  final controller = GetIt.I.get<EstablishmentRegistrationController>();

  @override
  void initState() {
    super.initState();

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
        onPressed: () {
          if (controller.formKey.currentState!.validate()) {
            controller.initNewEstablishment();
            Navigator.pop(context, controller.newEstablishmentData);
          }
        },
        child: const Icon(Icons.save),
      ),
      body: Center(
        child: Form(
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
      ),
    );
  }
}
