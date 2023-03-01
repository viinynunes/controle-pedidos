import 'package:controle_pedidos/src/core/configuration/firebase_configuration.dart';
import 'package:controle_pedidos/src/core/configuration/get_storage_configuration.dart';
import 'package:controle_pedidos/src/core/home/android_home_page.dart';
import 'package:controle_pedidos/src/core/onboarding/onboarding_page.dart';
import 'package:controle_pedidos/src/core/onboarding/store/onboarding_controller.dart';
import 'package:controle_pedidos/src/global_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'src/core/configuration/license_configuration.dart';
import 'src/modules/login/presenter/pages/android/android_login_page.dart';
import 'styles/color_schemes.g.dart';
import 'styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorageConfiguration.config();

  await MobileAds.instance.initialize();

  await FirebaseConfiguration.config();

  await initGlobalServiceLocator(initModules: false);

  LicenseConfiguration.config();

  runApp(
    MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snap) {
          if (snap.hasData) {
            return const AndroidHomePage();
          } else {
            return GetIt.I.get<OnboardingController>().showOnboardingPage()
                ? const OnboardingPage()
                : const AndroidLoginPage();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        elevatedButtonTheme: elevatedButtonTheme,
        fontFamily: fontFamily,
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        elevatedButtonTheme: elevatedButtonTheme,
        fontFamily: fontFamily,
        textTheme: textTheme,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt')],
    ),
  );
}
