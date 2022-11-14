import 'package:controle_pedidos/src/modules/core/widgets/custom_material_banner_error.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../store/stock_controller.dart';
import '../i_stock_page.dart';
import 'widgets/get_provider_by_date_widget.dart';
import 'widgets/provider_selection_and_stock_left.dart';
import 'widgets/stock_list_builder_widget.dart';
import 'widgets/stock_table_header_widget.dart';

class AndroidStockPage extends IStockPage {
  const AndroidStockPage({super.key, required super.productList});

  @override
  _AndroidStockPageState createState() => _AndroidStockPageState();
}

class _AndroidStockPageState extends IStockPageState {
  final controller = GetIt.I.get<StockController>();

  @override
  void initState() {
    super.initState();

    reaction((p0) => controller.error, (p0) {
      controller.error.map((error) {
        CustomMaterialBannerError.showMaterialBannerError(
            context: context, message: error.message, onClose: () {});
      });
    });

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
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => controller.callEntitySelection(context),
                child: const Text('Adicionar Produto'),
              ),
            ],
          ),
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
