import 'package:auto_size_text/auto_size_text.dart';
import 'package:controle_pedidos/src/core/helpers/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/ui/states/base_state.dart';
import '../../stores/login_controller.dart';
import 'android_signup_page.dart';
import 'dialogs/android_forget_password_dialog.dart';
import 'widgets/informative_navigation_widget.dart';
import 'widgets/login_background_widget.dart';

class AndroidLoginPage extends StatefulWidget {
  const AndroidLoginPage({Key? key}) : super(key: key);

  @override
  State<AndroidLoginPage> createState() => _AndroidLoginPageState();
}

class _AndroidLoginPageState
    extends BaseState<AndroidLoginPage, LoginController> {
  @override
  void onReady() {
    super.onReady();

    reaction((_) => controller.error, (_) {
      controller.error.map(
        (error) => showError(message: error.message),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const LoginBackgroundWidget(),
          SingleChildScrollView(
            child: Center(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          AutoSizeText(
                            'Bem Vindo!',
                            maxLines: 1,
                            minFontSize: 40,
                            maxFontSize: 50,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          AutoSizeText(
                            'Realize o login para ter acesso ao Controle de Pedidos',
                            minFontSize: 10,
                            maxFontSize: 20,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.9,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: controller.emailController,
                                decoration: const InputDecoration(
                                  label: Text(
                                    'Email',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  hintText: 'jose@hotmail.com',
                                  hintStyle: TextStyle(color: Colors.white24),
                                ),
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: controller.emailValidator,
                              ),
                              TextFormField(
                                controller: controller.passwordController,
                                decoration: const InputDecoration(
                                  label: Text(
                                    'Senha',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white24),
                                ),
                                style: const TextStyle(color: Colors.white),
                                onFieldSubmitted: (_) {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.login();
                                  }
                                },
                                obscureText: true,
                                obscuringCharacter: '*',
                                enableSuggestions: false,
                                autocorrect: false,
                                validator: controller.passwordValidator,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) =>
                                              const ForgetPasswordDialog());
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Esqueceu sua senha?',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Observer(builder: (context) {
                                return Visibility(
                                  visible: !controller.loading,
                                  replacement:
                                      const CircularProgressIndicator(),
                                  child: SizedBox(
                                    height: size.height * 0.06,
                                    width: size.width * 0.7,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (controller.formKey.currentState!
                                            .validate()) {
                                          controller.login();
                                        }
                                      },
                                      child: const Text('Login'),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              InformativeNavigationWidget(
                                informativeText: 'Não tem uma conta?',
                                actionText: 'Cadastre-se!',
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      CustomPageRoute(
                                          child: const AndroidSignupPage()));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
