import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:rect_getter/rect_getter.dart';

import '../../../../../core/helpers/custom_page_route.dart';
import '../../../../../domain/entities/client.dart';
import '../../../../../domain/entities/product.dart';
import '../../../../client/presenter/pages/android/android_client_registration_page.dart';
import '../../../../product/presenter/pages/android/pages/android_product_registration_page.dart';
import '../../stores/order_registration_controller.dart';
import '../i_order_registration_page.dart';
import 'menu/order_registration_menu.dart';
import 'tiles/android_order_item_registration_tile.dart';

class AndroidOrderRegistrationPage extends IOrderRegistrationPage {
  const AndroidOrderRegistrationPage(
      {super.key,
      super.order,
      required super.productList,
      required super.clientList});

  @override
  State<StatefulWidget> createState() => AndroidOrderRegistrationPageState();
}

class AndroidOrderRegistrationPageState extends IOrderRegistrationPageState<
    AndroidOrderRegistrationPage, OrderRegistrationController> {
  @override
  void initState() {
    super.initState();

    reaction((p0) => controller.error, (p0) {
      controller.error.map((error) {
        HapticFeedback.heavyImpact();
        showError(message: error.message);
      });
    });

    controller.initState(
        order: widget.order,
        productList: widget.productList,
        clientList: widget.clientList);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => TextButton(
            onPressed: () => controller.callEntitySelectionDialog(
                context: context, entityList: controller.clientList),
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => OrderRegistrationMenu(
                  onEditClient: () async {
                    Navigator.of(context).pop();
                    final result =
                        await Navigator.of(context).push(CustomPageRoute(
                            child: AndroidClientRegistrationPage(
                              client: controller.selectedClient,
                            ),
                            direction: AxisDirection.left));

                    if (result != null && result is Client) {
                      if (controller.selectedClient != null) {
                        widget.clientList.removeWhere(
                            (element) => element == controller.selectedClient);
                      }

                      widget.clientList.add(result);

                      controller.selectClient(result);
                    }
                  },
                  onRemoveClient: controller.selectedClient != null
                      ? () {
                          Navigator.of(context).pop();
                          controller.unselectClient();
                        }
                      : null,
                ),
              );
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
          IconButton(
              onPressed: () => controller.saveOrder(context),
              icon: const Icon(Icons.save)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addSelectedOrderItemToList();
        },
        child: const Icon(Icons.add),
      ),
      body: Observer(builder: (context) {
        if (controller.loading) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (_) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                            const SizedBox(height: 20),
                            Text(controller.loadingMessage)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return SafeArea(
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
                          child: Card(
                            child: TextFormField(
                              controller: controller.quantityController,
                              focusNode: controller.quantityFocus,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                labelText: 'QTD',
                                border: OutlineInputBorder(),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              validator: controller.quantityValidator,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  controller.callEntitySelectionDialog(
                                      context: context,
                                      entityList: controller.productList),
                              onTap: controller.quantityControllerTextSelection,
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: GestureDetector(
                            onTap: () => controller.callEntitySelectionDialog(
                                context: context,
                                entityList: controller.productList),
                            child: Card(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                        child: RectGetter(
                                          key: controller.rectKey,
                                          child: IconButton(
                                            onPressed: () => controller
                                                .callAddNoteDialog(context),
                                            icon: const Icon(Icons.note),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Observer(
                        builder: (_) {
                          var orderItemList = controller.orderItemList;

                          return orderItemList.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller:
                                      controller.orderItemListScrollController,
                                  itemCount: orderItemList.length,
                                  itemBuilder: (_, index) {
                                    final item = orderItemList[index];

                                    return AndroidOrderItemRegistrationTile(
                                      item: item,
                                      onLongPress: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (_) => OrderRegistrationMenu(
                                            onEditProduct: () async {
                                              Navigator.of(context).pop();
                                              final result = await Navigator.of(
                                                      context)
                                                  .push(CustomPageRoute(
                                                      child:
                                                          AndroidProductRegistrationPage(
                                                        product: item.product,
                                                      ),
                                                      direction:
                                                          AxisDirection.left));

                                              if (result != null &&
                                                  result is Product) {
                                                controller
                                                    .editProductFromOrderItemList(
                                                        result);
                                              }
                                            },
                                            onRemoveProduct: () {
                                              Navigator.of(context).pop();
                                              controller
                                                  .removeItemFromOrderItemList(
                                                      item);
                                            },
                                          ),
                                        );
                                      },
                                      increaseQuantity: () =>
                                          controller.updateOrderItemQuantity(
                                              item: item, increase: true),
                                      decreaseQuantity: () =>
                                          controller.updateOrderItemQuantity(
                                              item: item, increase: false),
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
        );
      }),
    );
  }
}
