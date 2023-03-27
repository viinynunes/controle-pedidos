import 'package:controle_pedidos/src/modules/stock/domain/usecases/increase_stock_total_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rect_getter/rect_getter.dart';

import '../../../../core/widgets/show_entity_selection_dialog.dart';
import '../../../../domain/entities/client.dart';
import '../../../../domain/entities/order.dart' as o;
import '../../../../domain/entities/order_item.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/models/order_item_model.dart';
import '../../../../domain/models/order_model.dart';
import '../../../product/domain/usecases/i_product_usecase.dart';
import '../../../stock/domain/usecases/decrease_stock_total_usecase.dart';
import '../../domain/usecase/i_order_usecase.dart';
import '../../errors/order_info_exception.dart';

part 'order_registration_controller.g.dart';

class OrderRegistrationController = _OrderRegistrationControllerBase
    with _$OrderRegistrationController;

abstract class _OrderRegistrationControllerBase with Store {
  final IOrderUsecase orderUsecase;
  final IProductUsecase productUsecase;
  final IncreaseStockTotalUsecase createStockUsecase;
  final DecreaseStockTotalUsecase decreaseStockTotalUsecase;

  _OrderRegistrationControllerBase(this.orderUsecase, this.productUsecase,
      this.createStockUsecase, this.decreaseStockTotalUsecase);

  @observable
  bool newOrder = true;
  @observable
  bool loading = false;
  @observable
  String loadingMessage = '';
  @observable
  Client? selectedClient;
  @observable
  OrderModel? newOrderData;
  @observable
  Product? selectedProduct;
  @observable
  OrderItem? selectedOrderItem;
  @observable
  var orderItemList = ObservableList<OrderItem>.of([]);
  late final List<OrderItem> oldOrderItemList;
  @observable
  var productList = ObservableList<Product>.of([]);
  @observable
  var clientList = ObservableList<Client>.of([]);
  @observable
  Option<OrderInfoException> error = none();
  @observable
  Option<o.Order> success = none();

  int listIndex = 0;

  final formKey = GlobalKey<FormState>();
  final rectKey = RectGetter.createGlobalKey();

  final quantityController = TextEditingController();
  final noteController = TextEditingController();
  final orderItemListScrollController = ScrollController();

  final quantityFocus = FocusNode();
  final noteFocus = FocusNode();

  @action
  initState(
      {required o.Order? order,
      required List<Product> productList,
      required List<Client> clientList}) {
    this.productList = ObservableList.of(productList);

    this.clientList = ObservableList.of(clientList);

    if (order != null) {
      newOrder = false;
      newOrderData = OrderModel.fromOrder(order: order);
      selectedClient = newOrderData?.client;
      orderItemList = ObservableList.of(newOrderData?.orderItemList ?? []);
      oldOrderItemList = newOrderData?.orderItemList
              .map((item) => OrderItemModel.fromOrderItem(item: item))
              .toList() ??
          [];
      listIndex = order.orderItemList.length;
      sortOrderItemList();
    }

    quantityController.text = '1';
  }

  @action
  dispose() {
    selectedClient = null;
    selectedProduct = null;
    selectedOrderItem = null;
    quantityController.dispose();
    orderItemList.clear();
  }

  @action
  callEntitySelectionDialog(
      {required BuildContext context, required List<Object> entityList}) async {
    await showDialog(
      context: context,
      builder: (_) => ShowEntitySelectionDialog(
        entityList: entityList,
        fromTileSelection: (entity) {
          if (entity != null && entity is Product) {
            selectedProductHandler(entity, true);
          }

          if (entity != null && entity is Client) {
            selectedClientHandler(entity);
          }
        },
        fromKeyboardSelection: (entity) {
          if (entity != null && entity is Product) {
            selectedProductHandler(entity, false);
          }

          if (entity != null && entity is Client) {
            selectedClientHandler(entity);
          }
        },
      ),
    );
  }

  @action
  selectedClientHandler(Client client) {
    selectClient(client);
    prepareToSelectNewProduct();
  }

  @action
  selectedProductHandler(Product product, bool fromTile) {
    if (fromTile) {
      selectProduct(product);
    } else {
      selectProduct(product);
      addSelectedOrderItemToList();
    }
  }

  @action
  callAddNoteDialog(BuildContext context) async {
    var rect = RectGetter.getRectFromKey(rectKey);

    noteFocus.requestFocus();

    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            rect!.left + 5, rect.top + 40, rect.right, rect.bottom),
        items: [
          PopupMenuItem(
            child: SizedBox(
              width: 500,
              child: TextField(
                focusNode: noteFocus,
                controller: noteController,
                decoration: InputDecoration(
                    labelText: 'Observação',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                onSubmitted: (text) {
                  noteController.text = text;
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ]);
  }

  @action
  selectProduct(Product product) {
    selectedProduct = product;
  }

  @action
  selectClient(Client client) {
    selectedClient = client;
  }

  @action
  unselectClient() {
    selectedClient = null;
  }

  @action
  addSelectedOrderItemToList() {
    initOrderItem();

    if (!formKey.currentState!.validate() || selectedOrderItem == null) {
      error = optionOf(OrderInfoException(
          'Nenhum produto selecionado ou quantidade invalida'));
      return;
    }

    if (orderItemList.contains(selectedOrderItem)) {
      error = optionOf(OrderInfoException('Produto já adicionado'));
      return;
    }

    orderItemList.add(selectedOrderItem!);
    listIndex++;
    sortOrderItemList();
    prepareToSelectNewProduct();
  }

  @action
  initOrderItem() {
    if (selectedProduct == null) {
      error = optionOf(OrderInfoException('Nenhum produto selecionado'));
      return;
    }

    selectedOrderItem = OrderItemModel(
        listIndex: listIndex,
        quantity: int.parse(quantityController.text),
        note: noteController.text,
        product: selectedProduct!);
  }

  @action
  prepareToSelectNewProduct() {
    selectedProduct = null;
    selectedOrderItem = null;
    quantityFocus.requestFocus();
    quantityController.text = '1';
    quantityControllerTextSelection();
    noteController.text = '';
  }

  quantityControllerTextSelection() {
    quantityController.selection = TextSelection(
        baseOffset: 0, extentOffset: quantityController.value.text.length);
  }

  @action
  removeItemFromOrderItemList(OrderItem item) {
    orderItemList.remove(item);
  }

  @action
  editProductFromOrderItemList(Product product) {
    var item = orderItemList
        .singleWhere((element) => element.product.id == product.id);

    item.product = product;

    final oldItem = oldOrderItemList
        .singleWhere((element) => element.product.id == product.id);

    oldItem.product = product;
  }

  @action
  initNewOrderData() {
    newOrderData = OrderModel(
        id: newOrderData?.id ?? '0',
        registrationDate: newOrderData?.registrationDate ?? DateTime.now(),
        registrationHour: newOrderData?.registrationHour ?? DateTime.now(),
        enabled: true,
        client: selectedClient!,
        orderItemList: orderItemList);
  }

  @action
  saveOrder(BuildContext context) async {
    if (orderItemList.isEmpty || selectedClient == null) {
      error = optionOf(OrderInfoException('Verifique os dados do pedido'));
      return;
    }

    loading = true;

    initNewOrderData();

    if (newOrder && newOrderData != null) {
      loadingMessage = 'Salvando o Pedido...\n Aguarde';
      final createOrderResult = await orderUsecase.createOrder(newOrderData!);

      if (createOrderResult.isRight()) {
        for (var orderItem in newOrderData!.orderItemList) {
          createStockUsecase(
            product: orderItem.product,
            date: newOrderData!.registrationDate,
            increaseQuantity: orderItem.quantity,
          );
        }
      }
    } else {
      loadingMessage = 'Atualizando o Pedido...\n Aguarde';
      final updateOrderResult = await orderUsecase.updateOrder(newOrderData!);

      if (updateOrderResult.isRight()) {
        for (var orderItem in newOrderData!.orderItemList) {
          await createStockUsecase(
            product: orderItem.product,
            date: newOrderData!.registrationDate,
            increaseQuantity: orderItem.quantity,
          );
        }

        for (var orderItem in oldOrderItemList) {
          await decreaseStockTotalUsecase(
            product: orderItem.product,
            date: newOrderData!.registrationDate,
            decreaseQuantity: orderItem.quantity,
          );
        }
      }

      loadingMessage = '';
      loading = false;
    }

    Navigator.of(context).pop();
  }

  sortOrderItemList() {
    orderItemList.sort((a, b) => b.listIndex.compareTo(a.listIndex));
  }

  String? quantityValidator(String? text) {
    var regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(text!);
    if (quantityController.text.isEmpty ||
        quantityController.text == '0' ||
        !regExp) {
      return 'Quantidade Inválida';
    }
    return null;
  }

  @action
  updateOrderItemQuantity({required OrderItem item, required bool increase}) {
    if (increase) {
      item.quantity++;
    } else {
      if (item.quantity > 1) {
        item.quantity--;
      }
    }

    orderItemList.remove(item);
    orderItemList.add(item);
    sortOrderItemList();
  }
}
