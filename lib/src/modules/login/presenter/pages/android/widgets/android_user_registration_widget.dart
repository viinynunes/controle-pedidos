import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../stores/signup_controller.dart';

class AndroidUserRegistrationWidget extends StatelessWidget {
  const AndroidUserRegistrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<SignupController>();

    return Column(
      children: [
        TextFormField(
          controller: controller.fullNameController,
          decoration: const InputDecoration(
              label: Text('Nome Completo'),
              hintText: 'Jose da Silva'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: controller.userFullNameValidator,
        ),
        TextFormField(
          controller: controller.emailController,
          decoration: const InputDecoration(
              label: Text('Email'),
              hintText: 'jose@hotmail.com'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: controller.emailValidator,
        ),
        TextFormField(
          controller: controller.phoneController,
          decoration: const InputDecoration(
              label: Text('Telefone'),
              hintText: '()_____-____'),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          controller: controller.passwordController,
          decoration: const InputDecoration(
              label: Text('Senha'),
              hintText: '************'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          obscureText: true,
          obscuringCharacter: '*',
          enableSuggestions: false,
          autocorrect: false,
          validator: controller.passwordValidator,
        ),
        TextFormField(
          controller: controller.confirmPasswordController,
          decoration: const InputDecoration(
              label: Text('Confirme sua Senha'),
              hintText: '************'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          obscureText: true,
          obscuringCharacter: '*',
          enableSuggestions: false,
          autocorrect: false,
          validator: controller.confirmPasswordValidator,
        ),
      ],
    );
  }
}
