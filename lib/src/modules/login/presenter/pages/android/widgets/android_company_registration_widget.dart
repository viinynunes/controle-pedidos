import 'package:controle_pedidos/src/modules/login/presenter/stores/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AndroidCompanyRegistrationWidget extends StatelessWidget {
  const AndroidCompanyRegistrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = GetIt.I.get<SignupController>();

    return Column(
      children: [
        TextFormField(
          controller: controller.companyNameController,
          decoration: const InputDecoration(
              label: Text('Nome da Empresa'),
              hintText: 'Jeferson Caminhões'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: controller.companyNameValidator,
        ),
      ],
    );
  }
}
