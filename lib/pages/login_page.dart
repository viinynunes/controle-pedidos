import 'package:controle_pedidos/model/user_model.dart';
import 'package:controle_pedidos/pages/home_page.dart';
import 'package:controle_pedidos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          Utils.buildBackground(),
          ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: desktop ? 720 : double.maxFinite),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            SizedBox(
                              height: desktop ? 150 : 100,
                            ),
                            Image.asset('assets/icon.png',
                                height: desktop ? 120 : 100),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Controle de Pedidos',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),

                            /*const Icon(
                              Icons.water_damage_outlined,
                              size: 150,
                              color: Colors.white,
                            ),*/

                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              autofillHints: const [AutofillHints.email],
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              validator: (text) {
                                bool regValida = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(text!);
                                if (text.isEmpty || !regValida) {
                                  return 'Email Inválido';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                hintText: 'Senha',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              autofillHints: const [AutofillHints.email],
                              style: const TextStyle(color: Colors.white),
                              obscureText: true,
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return 'Preencha o campo';
                                } else if (text.length < 6) {
                                  return 'A senha deve conter no minimo 6 caracteres';
                                }
                              },
                              onFieldSubmitted: (e) {
                                if (_formKey.currentState!.validate()) {
                                  model.signIn(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      onSuccess: onSuccess,
                                      onError: onError);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      model.signIn(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          onSuccess: onSuccess,
                                          onError: onError);
                                    }
                                  },
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              side: const BorderSide(
                                                  color: Colors.black))))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  void onSuccess() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  void onError() {
    _createSnackBar('Erro ao efetuar o login', Colors.redAccent);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _createSnackBar(
      String text, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
