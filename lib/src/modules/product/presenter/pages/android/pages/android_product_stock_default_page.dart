import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../core/ui/states/base_state.dart';
import '../../../../../../core/widgets/shimmer/shimer_widget.dart';
import '../../../../../../core/widgets/show_entity_selection_dialog.dart';
import '../../../../../../domain/entities/provider.dart';
import '../../../stores/product_stock_default_controller.dart';
import 'tiles/android_product_stock_default_tile.dart';

class AndroidProductStockDefaultPage extends StatefulWidget {
  const AndroidProductStockDefaultPage({Key? key}) : super(key: key);

  @override
  State<AndroidProductStockDefaultPage> createState() =>
      _AndroidProductStockDefaultPageState();
}

class _AndroidProductStockDefaultPageState extends BaseState<
    AndroidProductStockDefaultPage, ProductStockDefaultController> {
  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos Fixos'),
      ),
      body: SizedBox(
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
                  return controller.productList.isNotEmpty
                      ? AndroidProductStockDefaultTile(
                          productList: controller.productList,
                          onChanged: (product) {
                            controller.toggleCheckbox(product);
                            controller.updateProduct(product);
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
    );
  }
}
