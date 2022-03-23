import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:controle_pedidos/pages/home_page.dart';
import 'package:flutter/material.dart';

class InitialSplashScreen extends StatelessWidget {
  const InitialSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/icon.png'),
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.rotationTransition,
      backgroundColor: Colors.grey,
      duration: 10000,
    );
  }
}
