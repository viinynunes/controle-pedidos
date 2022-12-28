import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../stores/login_controller.dart';

class ForgetPasswordDialog extends StatelessWidget {
  const ForgetPasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<LoginController>();

    return AlertDialog(
      title: Observer(
          builder: (_) => controller.passwordResetEmailSentSucceffuly
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Email Enviado com sucesso',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Verifique também sua caixa de spam',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              : Column(
                  children: [
                    const Text('Esqueceu sua senha?'),
                    Text(
                      'Digite seu email para a recuperação',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                )),
      content: SingleChildScrollView(
        child: Observer(builder: (_) {
          return controller.passwordResetEmailSentSucceffuly
              ? Container()
              : Column(
                  children: [
                    TextField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        hintText: 'jose@hotmail.com',
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.sendPasswordResetEmail();
                      },
                      child: const Text('Enviar Link'),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
