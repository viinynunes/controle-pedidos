import 'package:flutter/material.dart';

import '../../domain/entities/client.dart';

abstract class IClientRegistrationPage extends StatefulWidget {
  const IClientRegistrationPage({super.key, this.client});

  final Client? client;
}

abstract class IClientRegistrationPageState<
    Page extends IClientRegistrationPage> extends State<Page> {}
