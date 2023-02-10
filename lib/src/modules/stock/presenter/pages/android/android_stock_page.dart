import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/helpers/custom_page_route.dart';
import '../../../../product/presenter/pages/android/pages/android_product_stock_default_page.dart';
import '../../store/stock_controller.dart';
import '../i_stock_page.dart';
import 'android_share_stock_list_by_provider_page.dart';
import 'widgets/get_provider_by_date_widget.dart';
import 'widgets/provider_selection_and_stock_left.dart';
import 'widgets/stock_list_builder_widget.dart';
import 'widgets/stock_table_header_widget.dart';

class AndroidStockPage extends IStockPage {
  const AndroidStockPage({super.key});

  @override
  _AndroidStockPageState createState() => _AndroidStockPageState();
}

class _AndroidStockPageState
    extends IStockPageState<AndroidStockPage, StockController> {
  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    reaction((_) => controller.success, (_) {
      controller.success.map((_) => showSuccess(message: 'Sucesso'));
    });

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
        centerTitle: false,
        actions: [
          Observer(
            builder: (_) => controller.stockList.isNotEmpty
                ? IconButton(
                    onPressed: controller.getStockListByProviderBetweenDates,
                    icon: const Icon(Icons.refresh))
                : Container(),
          ),
          Observer(
            builder: (context) => controller.stockList.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).push(CustomPageRoute(
                          child: AndroidShareStockListByProviderPage(
                            providerName: controller.selectedProvider?.name ??
                                'Nenhum Fornecedor Selecionado',
                            stockList: controller.selectedStockList.isEmpty
                                ? controller.stockList
                                : controller.selectedStockList,
                          ),
                          direction: AxisDirection.left));
                    },
                    icon: const Icon(Icons.share))
                : Container(),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Adicionar Produto'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Carregar Produtos Fixos'),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text('Editar Produtos Fixos'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  {
                    controller.showEntitySelectionDialog(context);
                    break;
                  }
                case 2:
                  {
                    controller.loadStockDefault();
                    break;
                  }
                case 3:
                  {
                    Navigator.of(context).push(
                      CustomPageRoute(
                          child: const AndroidProductStockDefaultPage(),
                          direction: AxisDirection.left),
                    );
                  }
              }
            },
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
