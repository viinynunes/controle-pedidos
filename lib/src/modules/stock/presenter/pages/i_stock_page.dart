import 'package:flutter/material.dart';

import '../../../../core/ui/states/base_state.dart';

abstract class IStockPage extends StatefulWidget {
  const IStockPage({Key? key}) : super(key: key);
}

abstract class IStockPageState<Page extends IStockPage, C extends Object> extends BaseState<Page, C> {}
