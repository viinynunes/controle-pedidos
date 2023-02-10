import 'package:flutter/material.dart';

import '../../../../core/ui/states/base_state.dart';
import '../../../../domain/entities/client.dart';

abstract class IClientRegistrationPage extends StatefulWidget {
  const IClientRegistrationPage({super.key, this.client});

  final Client? client;
}

abstract class IClientRegistrationPageState<
    Page extends IClientRegistrationPage,
    C extends Object> extends BaseState<Page, C> {}
