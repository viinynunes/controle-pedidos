import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../store/stock_controller.dart';
import '../i_stock_page.dart';
import 'widgets/get_provider_by_date_widget.dart';
import 'widgets/provider_selection_and_stock_left.dart';
import 'widgets/stock_list_builder_widget.dart';
import 'widgets/stock_table_header_widget.dart';

class AndroidStockPage extends IStockPage {
  const AndroidStockPage({Key? key}) : super(key: key);

  @override
  _AndroidStockPageState createState() => _AndroidStockPageState();
}

class _AndroidStockPageState extends IStockPageState {
  final controller = GetIt.I.get<StockController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: const [
              GetProviderByDateWidget(),
              ProviderSelectionAndStockLeftWidget(),
              StockTableHeaderWidget(),
              StockListBuilderWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
