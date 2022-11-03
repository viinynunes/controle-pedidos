import 'package:flutter/material.dart';

import '../../../../domain/entities/provider.dart';

abstract class IProviderRegistrationPage extends StatefulWidget {
  const IProviderRegistrationPage({super.key, this.provider});

  final Provider? provider;
}

abstract class IProviderRegistrationPageState<
    Page extends IProviderRegistrationPage> extends State<Page> {}
