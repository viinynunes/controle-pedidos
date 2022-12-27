import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../stores/login_controller.dart';

class AndroidLoginPage extends StatefulWidget {
  const AndroidLoginPage({Key? key}) : super(key: key);

  @override
  State<AndroidLoginPage> createState() => _AndroidLoginPageState();
}

class _AndroidLoginPageState extends State<AndroidLoginPage> {
  final controller = GetIt.I.get<LoginController>();

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map(
        (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
          ),
        ),
      );
    });

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login_background.jpg'),
                    colorFilter:
                        ColorFilter.mode(Colors.black87, BlendMode.darken),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Form(
                key: controller.formKey,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Bem Vindo !',
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Realize o login para ter acesso ao Controle de Pedidos',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.5,
                        width: size.width * 0.9,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                TextFormField(
                                  controller: controller.emailController,
                                  decoration: const InputDecoration(
                                      label: Text('Email'),
                                      hintText: 'jose@hotmail.com'),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: controller.emailValidator,
                                ),
                                SizedBox(height: size.height * 0.05),
                                TextFormField(
                                  controller: controller.passwordController,
                                  decoration: const InputDecoration(
                                      label: Text('Senha'),
                                      hintText: '*****************'),
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  validator: controller.passwordValidator,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Observer(
                                              builder: (_) => controller
                                                      .passwordResetEmailSentSucceffuly
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Email Enviado com sucesso',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge,
                                                        ),
                                                        const SizedBox(height: 15),
                                                        Text(
                                                          'Verifique também sua caixa de spam',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        const Text(
                                                            'Esqueceu sua senha?'),
                                                        Text(
                                                          'Digite seu email para a recuperação',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall,
                                                        ),
                                                      ],
                                                    )),
                                          content: SingleChildScrollView(
                                            child: Observer(builder: (_) {
                                              return controller
                                                      .passwordResetEmailSentSucceffuly
                                                  ? Container()
                                                  : Column(
                                                      children: [
                                                        TextField(
                                                          controller: controller
                                                              .emailController,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'jose@hotmail.com',
                                                            labelText: 'Email',
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            await controller
                                                                .sendPasswordResetEmail();
                                                          },
                                                          child: const Text(
                                                              'Enviar Link'),
                                                        ),
                                                      ],
                                                    );
                                            }),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Esqueceu sua senha?',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: size.height * 0.06,
                                  width: size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: controller.login,
                                    child: Observer(
                                      builder: (_) => controller.loading
                                          ? const CircularProgressIndicator()
                                          : const Text('Login'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Não tem uma conta?',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Cadastre-se!',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
