import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/drawer_page_controller.dart';
import 'package:controle_pedidos/model/establishment_model.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/model/provider_model.dart';
import 'package:controle_pedidos/model/user_model.dart';
import 'package:controle_pedidos/pages/home_page.dart';
import 'package:controle_pedidos/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<ClientModel>(
            model: ClientModel(),
            child: ScopedModel<DrawerPageController>(
              model: DrawerPageController(),
              child: ScopedModel<OrderModel>(
                model: OrderModel(),
                child: ScopedModel<ProductModel>(
                  model: ProductModel(),
                  child: ScopedModel<ProviderModel>(
                    model: ProviderModel(),
                    child: ScopedModel<EstablishmentModel>(
                      model: EstablishmentModel(),
                      child: MaterialApp(
                        home:
                            model.isLoggedIn() ? const HomePage() : const LoginPage(),
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
