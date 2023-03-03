import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseConfiguration {
  static Future<void> config() async {
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
  }
}
