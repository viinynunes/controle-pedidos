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
                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      const Text(
                        'Realize o login',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const Icon(
                        Icons.water_damage_outlined,
                        size: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
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
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Preencha o campo';
                          } else if (text.length < 6) {
                            return 'A senha deve conter no minimo 6 caracteres';
                          }
                        },
                        onFieldSubmitted: (e){
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
