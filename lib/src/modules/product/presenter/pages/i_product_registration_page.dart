import 'package:controle_pedidos/src/modules/product/domain/entities/product.dart';
import 'package:flutter/material.dart';

abstract class IProductRegistrationPage extends StatefulWidget {
  const IProductRegistrationPage({super.key, this.product});

  final Product? product;
}

abstract class IProductRegistrationPageState<
    Page extends IProductRegistrationPage> extends State<Page> {}
