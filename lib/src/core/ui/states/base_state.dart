import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../helpers/messages.dart';

abstract class BaseState<T extends StatefulWidget, C extends Object>
    extends State<T> with Messages {
  late final C controller;

  @override
  void initState() {
    super.initState();

    controller = GetIt.I.get<C>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onReady();
    });
  }

  void onReady() {}
}
