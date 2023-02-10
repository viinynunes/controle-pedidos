import 'package:controle_pedidos/src/domain/entities/establishment.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/states/base_state.dart';

abstract class IEstablishmentRegistrationPage extends StatefulWidget {
  const IEstablishmentRegistrationPage({super.key, this.establishment});

  final Establishment? establishment;
}

abstract class IEstablishmentRegistrationPageState<
    Page extends IEstablishmentRegistrationPage, C extends Object> extends BaseState<Page, C> {}
