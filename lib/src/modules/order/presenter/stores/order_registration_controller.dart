import 'package:controle_pedidos/src/domain/entities/order.dart' as o;
import 'package:controle_pedidos/src/domain/models/order_model.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/client.dart';
import '../../../../domain/entities/order_item.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/models/order_item_model.dart';
import '../../../core/widgets/show_entity_selection_dialog.dart';
import '../../errors/order_error.dart';

part 'order_registration_controller.g.dart';

class OrderRegistrationController = _OrderRegistrationControllerBase
    with _$OrderRegistrationController;

abstract class _OrderRegistrationControllerBase with Store {
  final IOrderUsecase orderUsecase;

  _OrderRegistrationControllerBase(this.orderUsecase);

  @observable
  bool newOrder = false;
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
  @observable
  var productList = ObservableList<Product>.of([]);
  @observable
  var clientList = ObservableList<Client>.of([]);
  @observable
  Option<OrderError> error = none();

  int listIndex = 0;

  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final noteController = TextEditingController();
  final orderItemListScrollController = ScrollController();

  final quantityFocus = FocusNode();

  @action
  callEntitySelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => ShowEntitySelectionDialog(
        entityList: productList,
        fromTileSelection: (entity) {
          if (entity != null && entity is Product) {
            selectProduct(entity);
          }
        },
        fromKeyboardSelection: (entity) {
          if (entity != null && entity is Product) {
            selectedProduct = entity;
            addSelectedOrderItemToList();
          }
        },
      ),
    );
  }

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
      sortOrderItemList();
    }

    quantityController.text = '1';
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
  addSelectedOrderItemToList() {
    initOrderItem();

    if (formKey.currentState!.validate() && selectedOrderItem != null) {
      if (orderItemList.contains(selectedOrderItem)) {
        error = optionOf(OrderError('Produto já adicionado'));
      } else {
        orderItemList.add(selectedOrderItem!);
        listIndex++;
        sortOrderItemList();
      }
      prepareToSelectNewProduct();
    } else {
      error = optionOf(OrderError('Nenhum produto selecionado'));
    }
  }

  @action
  initOrderItem() {
    if (selectedProduct != null) {
      selectedOrderItem = OrderItemModel(
          listIndex: listIndex,
          productId: selectedProduct!.id,
          quantity: int.parse(quantityController.text),
          note: noteController.text,
          product: selectedProduct!);
    }
  }

  @action
  prepareToSelectNewProduct() {
    selectedProduct = null;
    selectedOrderItem = null;
    quantityFocus.requestFocus();
    quantityController.text = '1';
    quantityController.selection = TextSelection(
        baseOffset: 0, extentOffset: quantityController.value.text.length);
    noteController.text = '';
  }

  @action
  removeItemFromOrderItemList(OrderItem item) {
    orderItemList.remove(item);
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
}
