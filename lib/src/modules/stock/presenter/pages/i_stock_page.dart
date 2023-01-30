import 'package:flutter/material.dart';

abstract class IStockPage extends StatefulWidget {
  const IStockPage({Key? key}) : super(key: key);
}

abstract class IStockPageState<Page extends IStockPage> extends State<Page> {}
