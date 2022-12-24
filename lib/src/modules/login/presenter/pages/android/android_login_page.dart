import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../../core/helpers/custom_page_route.dart';
import '../../../../../core/home/android_home_page.dart';
import '../../stores/login_controller.dart';

class AndroidCompanyRegistrationPage extends StatelessWidget {
  const AndroidCompanyRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final controller = GetIt.I.get<LoginController>();

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
                                  decoration: const InputDecoration(
                                      label: Text('Email'),
                                      hintText: 'jose@hotmail.com'),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (text) {
                                    if (!isEmail(text!)) {
                                      return 'Email inválido';
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(height: size.height * 0.05),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      label: Text('Senha'),
                                      hintText: '*****************'),
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {},
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
                                    onPressed: () {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        Navigator.of(context).push(
                                            CustomPageRoute(
                                                child: const AndroidHomePage(),
                                                direction: AxisDirection.up));
                                      }
                                    },
                                    child: const Text('Login'),
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
