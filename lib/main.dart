import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/establishment_model.dart';
import 'package:controle_pedidos/model/order_item_model.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/model/provider_model.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:controle_pedidos/model/user_model.dart';
import 'package:controle_pedidos/pages/home_page.dart';
import 'package:controle_pedidos/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

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
                            primarySwatch: Colors.deepPurple,
                            primaryColor: Colors.deepPurple,
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
