import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'store/onboarding_controller.dart';
import 'widgets/custom_paginator.dart';
import 'widgets/onboarding_main_widget.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = GetIt.I.get<OnboardingController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.changePage,
              physics: const ClampingScrollPhysics(),
              children: const [
                OnboardingMainWidget(
                  title: 'Cadastre seus Pedidos',
                  subtitle:
                      'De forma simples, é possivel registrar todos os pedidos recebidos de seus clientes. Os pedidos ficam salvos e podem ser acessados de qualquer dispositivo.',
                  imagePath: 'assets/ob_black.png',
                  darkImagePath: 'assets/ob_white.png',
                ),
                OnboardingMainWidget(
                  title: 'Gerencie seu Estoque',
                  subtitle:
                      'Controle a quantidade dos itens que serão pedidos para seus fornecedores de forma simples, podendo escolher entre diversos dias diferentes.',
                  imagePath: 'assets/ob_black.png',
                  darkImagePath: 'assets/ob_white.png',
                ),
                OnboardingMainWidget(
                  title: 'Gere Relatórios',
                  subtitle:
                      'É possivel gerar relatórios tanto em imagem ou relatórios gerais como pedidos e estoque em xlsx.',
                  imagePath: 'assets/ob_black.png',
                  darkImagePath: 'assets/ob_white.png',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * .15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Observer(builder: (context) {
                  return CustomPaginator(currentPage: controller.currentPage);
                }),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * .15,
              width: size.width * .9,
              padding: EdgeInsets.only(bottom: size.height * .06),
              child: ElevatedButton(
                onPressed: () => controller.currentPage == 2
                    ? controller.closeOnboarding(context)
                    : controller.nextPage(),
                child: Observer(
                  builder: (context) =>
                      Text(controller.currentPage == 2 ? 'ACESSAR' : 'PRÓXIMO'),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
