import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:flutter/material.dart';

abstract class IEstablishmentRegistrationPage extends StatefulWidget {
  const IEstablishmentRegistrationPage({super.key, this.establishment});

  final Establishment? establishment;
}

abstract class IEstablishmentRegistrationPageState<
    Page extends IEstablishmentRegistrationPage> extends State<Page> {}
