import 'package:auto_size_text/auto_size_text.dart';
import 'package:controle_pedidos/src/core/helpers/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../stores/login_controller.dart';
import 'android_signup_page.dart';
import 'dialogs/android_forget_password_dialog.dart';
import 'widgets/informative_navigation_widget.dart';

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
                          children: [
                            SizedBox(
                              width: size.width * 0.9,
                              child: const AutoSizeText(
                                'Bem Vindo!',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.9,
                              child: const AutoSizeText(
                                'Realize o login para ter acesso ao Controle de Pedidos',
                                minFontSize: 10,
                                maxFontSize: 20,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width * 0.9,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                TextFormField(
                                  controller: controller.emailController,
                                  decoration: const InputDecoration(
                                    label: Text(
                                      'Email',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    hintText: 'jose@hotmail.com',
                                    hintStyle: TextStyle(color: Colors.white),
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
                                    hintText: '*****************',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: const TextStyle(color: Colors.white),
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
                                          style:
                                              TextStyle(color: Colors.orange),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
