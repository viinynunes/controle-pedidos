import 'package:controle_pedidos/src/modules/login/presenter/pages/android/android_login_page.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../services/onboarding_service.dart';
import '../../helpers/custom_page_route.dart';

part 'onboarding_controller.g.dart';

class OnboardingController = _OnboardingControllerBase
    with _$OnboardingController;

abstract class _OnboardingControllerBase with Store {
  late final PageController pageController;
  final OnboardingService onboardingService;

  _OnboardingControllerBase(this.onboardingService);

  @observable
  int currentPage = 0;

  @action
  initState() {
    pageController = PageController();
  }

  @action
  changePage(int page) {
    currentPage = page;
  }

  @action
  nextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  closeOnboarding(BuildContext context) {
    onboardingService.dontShowAgain();

    Navigator.of(context)
        .pushReplacement(CustomPageRoute(child: const AndroidLoginPage()));
  }

  bool showOnboardingPage() {
    return onboardingService.showOnboarding();
  }
}
