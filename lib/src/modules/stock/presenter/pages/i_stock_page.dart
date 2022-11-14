import 'package:flutter/material.dart';

import '../../../../domain/entities/product.dart';

abstract class IStockPage extends StatefulWidget {
  const IStockPage({Key? key, required this.productList}) : super(key: key);

  final List<Product> productList;
}

abstract class IStockPageState<Page extends IStockPage> extends State<Page> {}
