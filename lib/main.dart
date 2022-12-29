import 'package:controle_pedidos/src/core/home/android_home_page.dart';
import 'package:controle_pedidos/src/global_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/modules/login/presenter/pages/android/android_login_page.dart';
import 'styles/color_schemes.g.dart';
import 'styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCFGTe4EV1NyD3q65xCggS9Wvs_wxYHJ2I",
          appId: "1:242675882008:web:9aa50610ad1af3e8f18b6d",
          messagingSenderId: "242675882008",
          projectId: "controle-de-pedidos-ca8b2"),
    );
  } catch (e) {
    debugPrint(e.toString());
  }

  await initGlobalServiceLocator();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);

    final imgLicense = await rootBundle
        .loadString('<a href="https://www.freepik.com/free-vector/'
            'neon-purple-lights-background-arrow-style_8152351'
            '.htm#page=4&query=background&position=31&from_view=search&track='
            'sph">Image by starline</a> on Freepik');

    yield LicenseEntryWithLineBreaks(['freepick'], imgLicense);
  });

  runApp(
    MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snap) {
          if (snap.hasData) {
            return const AndroidHomePage();
          } else {
            return const AndroidLoginPage();
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
