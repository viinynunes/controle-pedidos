import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/core/widgets/show_entity_selection_dialog.dart';
import 'package:controle_pedidos/src/modules/order/presenter/pages/android/android_order_registration_tile.dart';
import 'package:controle_pedidos/src/modules/order/presenter/pages/i_order_registration_page.dart';
import 'package:controle_pedidos/src/modules/order/presenter/stores/order_registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../../domain/entities/client.dart';

class AndroidOrderRegistrationPage extends IOrderRegistrationPage {
  const AndroidOrderRegistrationPage(
      {super.key,
      super.order,
      required super.productList,
      required super.clientList});

  @override
  State<StatefulWidget> createState() => AndroidOrderRegistrationPageState();
}

class AndroidOrderRegistrationPageState extends IOrderRegistrationPageState {
  final controller = GetIt.I.get<OrderRegistrationController>();

  @override
  void initState() {
    super.initState();

    reaction((p0) => controller.error, (p0) {
      controller.error.map((error) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Center(child: Text(error.message))),
          backgroundColor: Theme.of(context).errorColor,
        ));
      });
    });

    controller.initState(
        order: widget.order,
        productList: widget.productList,
        clientList: widget.clientList);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => TextButton(
            onPressed: () async {
              final selectedClient = await showDialog(
                  context: context,
                  builder: (_) => ShowEntitySelectionDialog(
                      entityList: controller.clientList));

              if (selectedClient != null &&
                  selectedClient is Client) {
                controller.selectClient(selectedClient);
              }
            },
            child: Text(
              controller.selectedClient?.name ?? 'Selecione o cliente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.orderItemList.length.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addSelectedOrderItemToList();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: TextFormField(
                            controller: controller.quantityController,
                            focusNode: controller.quantityFocus,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              labelText: 'QTD',
                              border: OutlineInputBorder(),
                            ),
                            validator: controller.quantityValidator),
                      ),
                      SizedBox(width: size.width * 0.03),
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () async {
                            final selectedProduct = await showDialog(
                                context: context,
                                builder: (_) => ShowEntitySelectionDialog(
                                    entityList: controller.productList));

                            if (selectedProduct != null &&
                                selectedProduct is Product) {
                              controller.selectProduct(selectedProduct);
                            }
                          },
                          child: Container(
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Observer(
                                  builder: (_) => Flexible(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.selectedProduct
                                                ?.toString() ??
                                            'Selecione um produto',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.note),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Observer(
                      builder: (_) {
                        var orderItemList = controller.orderItemList;

                        return orderItemList.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: orderItemList.length,
                                itemBuilder: (_, index) {
                                  final item = orderItemList[index];

                                  return AndroidOrderItemRegistrationTile(
                                    item: item,
                                    onRemove: () => controller
                                        .removeItemFromOrderItemList(item),
                                    onEdit: () {},
                                  );
                                },
                              )
                            : const Center(
                                child: Text('Nenhum produto selecionado'),
                              );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
