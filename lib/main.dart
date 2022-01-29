import 'package:controle_pedidos/model/user_model.dart';
import 'package:controle_pedidos/pages/LoginPage.dart';
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
            return MaterialApp(
                home: const LoginPage(),
                theme: ThemeData(
                  primarySwatch: Colors.deepPurple,
                  primaryColor: Colors.red,
                  inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                ));
          },
        )),
  );
}
