import 'package:auto_size_text/auto_size_text.dart';
import 'package:controle_pedidos/src/core/helpers/custom_page_route.dart';
import 'package:controle_pedidos/src/core/home/android_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../stores/signup_controller.dart';
import 'android_login_page.dart';
import 'widgets/informative_navigation_widget.dart';
import 'widgets/login_background_widget.dart';

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
                        children: [
                          const AutoSizeText(
                            'Cadastre-se',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Observer(
                            builder: (context) => AutoSizeText(
                              controller.showCompanyFields
                                  ? 'Primeiro, digite as informações de sua empresa'
                                  : 'Agora, digite as suas informações',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
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
                                ? Column(
                                    children: [
                                      TextFormField(
                                        controller:
                                            controller.companyNameController,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            'Nome da Empresa',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          hintText: 'Jeferson Caminhões',
                                          hintStyle:
                                              TextStyle(color: Colors.white24),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator:
                                            controller.companyNameValidator,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: controller
                                              .toggleShowCompanyFields,
                                          child: const Icon(Icons.arrow_back)),
                                      TextFormField(
                                        controller:
                                            controller.fullNameController,
                                        focusNode: controller.fullNameFocus,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            'Nome Completo',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          hintText: 'Jose da Silva',
                                          hintStyle:
                                              TextStyle(color: Colors.white24),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator:
                                            controller.userFullNameValidator,
                                      ),
                                      TextFormField(
                                        controller: controller.emailController,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            'Email',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          hintText: 'jose@hotmail.com',
                                          hintStyle:
                                              TextStyle(color: Colors.white24),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator: controller.emailValidator,
                                      ),
                                      TextFormField(
                                        controller: controller.phoneController,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            'Telefone',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          hintText: '()_____-____',
                                          hintStyle:
                                              TextStyle(color: Colors.white24),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      TextFormField(
                                        controller:
                                            controller.passwordController,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            'Senha',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          hintText: '************',
                                          hintStyle:
                                              TextStyle(color: Colors.white24),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        obscureText: true,
                                        obscuringCharacter: '*',
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        validator: controller.passwordValidator,
                                      ),
                                      TextFormField(
                                        controller: controller
                                            .confirmPasswordController,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            'Confirme sua Senha',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          hintText: '************',
                                          hintStyle:
                                              TextStyle(color: Colors.white24),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        obscureText: true,
                                        obscuringCharacter: '*',
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        validator:
                                            controller.confirmPasswordValidator,
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (controller.showCompanyFields &&
                                        controller.isFormKeyValidated()) {
                                      controller.toggleShowCompanyFields();
                                    } else {
                                      controller.signup(
                                          onSignupSucceffuly: () => Navigator
                                                  .of(context)
                                              .pushReplacement(CustomPageRoute(
                                                  child:
                                                      const AndroidHomePage())));
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
                                                    const SizedBox(width: 10),
                                                    const Icon(
                                                        Icons.arrow_right_alt)
                                                  ]
                                                : [
                                                    controller.loading
                                                        ? const CircularProgressIndicator()
                                                        : const Text(
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
                                InformativeNavigationWidget(
                                  informativeText: 'Já possui uma conta?',
                                  actionText: 'Faça o login!',
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        CustomPageRoute(
                                            child: const AndroidLoginPage()));
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
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
