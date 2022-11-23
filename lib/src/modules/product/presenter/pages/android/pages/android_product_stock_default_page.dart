import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/core/widgets/shimmer/shimer_widget.dart';
import 'package:controle_pedidos/src/modules/core/widgets/show_entity_selection_dialog.dart';
import 'package:controle_pedidos/src/modules/product/presenter/stores/product_stock_default_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'tiles/android_product_stock_default_tile.dart';

class AndroidProductStockDefaultPage extends StatefulWidget {
  const AndroidProductStockDefaultPage({Key? key}) : super(key: key);

  @override
  State<AndroidProductStockDefaultPage> createState() =>
      _AndroidProductStockDefaultPageState();
}

class _AndroidProductStockDefaultPageState
    extends State<AndroidProductStockDefaultPage> {
  final controller = GetIt.I.get<ProductStockDefaultController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos Fixos'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Observer(
                  builder: (_) => controller.loading
                      ? ShimmerWidget.rectangular(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.5,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final entity = await showDialog(
                                      context: context,
                                      builder: (_) => ShowEntitySelectionDialog(
                                          entityList: controller.providerList));

                                  if (entity != null && entity is Provider) {
                                    controller.setSelectedProvider(entity);
                                    controller.getProductListByProvider();
                                  }
                                },
                                child: Text(controller.selectedProvider?.name ??
                                    'Selecione um fornecedor'),
                              ),
                            ),
                          ),
                        ),
                ),
                Expanded(
                  child: Observer(builder: (_) {
                    var productList = controller.productList;

                    return productList.isNotEmpty
                        ? ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (_, index) {
                              final product = productList[index];

                              return AndroidProductStockDefaultTile(
                                product: product,
                                onChecked: () {
                                  controller.toggleCheckbox(product);
                                  controller.updateProduct(product);
                                },
                              );
                            },
                          )
                        : const Center(
                            child: Text('Nenhum produto encontrado'),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
