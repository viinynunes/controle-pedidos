import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/states/base_state.dart';

abstract class IProductRegistrationPage extends StatefulWidget {
  const IProductRegistrationPage({super.key, this.product});

  final Product? product;
}

abstract class IProductRegistrationPageState<
    Page extends IProductRegistrationPage, C extends Object> extends BaseState<Page, C> {}
