import 'package:flutter/material.dart';

import '../../../../core/ui/states/base_state.dart';
import '../../../../domain/entities/client.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/entities/product.dart';

abstract class IOrderRegistrationPage extends StatefulWidget {
  const IOrderRegistrationPage(
      {super.key,
      this.order,
      required this.productList,
      required this.clientList});

  final Order? order;
  final List<Product> productList;
  final List<Client> clientList;
}

abstract class IOrderRegistrationPageState<Page extends IOrderRegistrationPage, C extends Object>
    extends BaseState<Page, C> {}
