import 'package:controle_pedidos/src/core/home/android_home_page.dart';
import 'package:controle_pedidos/src/global_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/modules/login/presenter/pages/android/android_login_page.dart';

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
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.sacramento().fontFamily,
        textTheme: const TextTheme(
            labelSmall: TextStyle(color: Colors.green),
            titleLarge: TextStyle(fontWeight: FontWeight.w600)),
        canvasColor: Colors.white,
        hintColor: Colors.grey,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 5),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(
            labelSmall: TextStyle(color: Colors.green),
            titleLarge: TextStyle(fontWeight: FontWeight.w600)),
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

/* void main() async {
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
    print(e);
  }

  runApp(
    ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<StockModel>(
            model: StockModel(),
            child: ScopedModel<ClientModel>(
              model: ClientModel(),
              child: ScopedModel<OrderModel>(
                model: OrderModel(),
                child: ScopedModel<OrderItemModel>(
                  model: OrderItemModel(),
                  child: ScopedModel<ProductModel>(
                    model: ProductModel(),
                    child: ScopedModel<ProviderModel>(
                      model: ProviderModel(),
                      child: ScopedModel<EstablishmentModel>(
                        model: EstablishmentModel(),
                        child: MaterialApp(
                          debugShowCheckedModeBanner: false,
                          home: model.isLoggedIn()
                              ? const HomePage()
                              : const LoginPage(),
                          theme: ThemeData(
                            useMaterial3: true,
                            inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)))),
                          ),
                          localizationsDelegates: const [
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate
                          ],
                          supportedLocales: const [Locale('pt')],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
*/
