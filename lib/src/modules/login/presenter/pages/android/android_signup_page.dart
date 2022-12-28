import 'package:controle_pedidos/src/core/helpers/custom_page_route.dart';
import 'package:controle_pedidos/src/modules/login/presenter/pages/android/widgets/android_user_registration_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../stores/signup_controller.dart';
import 'android_login_page.dart';
import 'widgets/android_company_registration_widget.dart';

class AndroidSignupPage extends StatefulWidget {
  const AndroidSignupPage({Key? key}) : super(key: key);

  @override
  State<AndroidSignupPage> createState() => _AndroidSignupPageState();
}

class _AndroidSignupPageState extends State<AndroidSignupPage> {
  final controller = GetIt.I.get<SignupController>();

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
                            const Text(
                              'Cadastre-se',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Observer(
                              builder: (context) => Text(
                                controller.showCompanyFields
                                    ? 'Primeiro, digite as informações de sua empresa'
                                    : 'Agora, digite as suas informações',
                                style: const TextStyle(fontSize: 14),
                              ),
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
                        child: Observer(builder: (_) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              controller.showCompanyFields
                                  ? const AndroidCompanyRegistrationWidget()
                                  : const AndroidUserRegistrationWidget(),
                              const SizedBox(height: 20),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.06,
                                    width: size.width * 0.7,
                                    child: TextButton(
                                      onPressed: () {
                                        if (controller.showCompanyFields &&
                                            controller.isFormKeyValidated()) {
                                          controller.toggleShowCompanyFields();
                                        } else {
                                          controller.signup();
                                        }
                                      },
                                      child: Observer(
                                        builder: (_) => controller.loading
                                            ? const CircularProgressIndicator()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: controller
                                                        .showCompanyFields
                                                    ? [
                                                        const Text('Próximo'),
                                                        const SizedBox(
                                                            width: 10),
                                                        const Icon(Icons
                                                            .arrow_right_alt)
                                                      ]
                                                    : [
                                                        const Text(
                                                          'Criar Conta',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Já possui uma conta?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushReplacement(CustomPageRoute(
                                                    child:
                                                        const AndroidLoginPage(),
                                                    direction:
                                                        AxisDirection.right));
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Faça o login!',
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
                          );
                        }),
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
