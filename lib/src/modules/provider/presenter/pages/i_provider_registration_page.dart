import 'package:flutter/material.dart';

import '../../../../core/ui/states/base_state.dart';
import '../../../../domain/entities/provider.dart';

abstract class IProviderRegistrationPage extends StatefulWidget {
  const IProviderRegistrationPage({super.key, this.provider});

  final Provider? provider;
}

abstract class IProviderRegistrationPageState<
    Page extends IProviderRegistrationPage,
    C extends Object> extends BaseState<Page, C> {}
