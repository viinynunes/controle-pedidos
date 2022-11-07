// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_registration_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderRegistrationController on _OrderRegistrationControllerBase, Store {
  late final _$newOrderAtom =
      Atom(name: '_OrderRegistrationControllerBase.newOrder', context: context);

  @override
  bool get newOrder {
    _$newOrderAtom.reportRead();
    return super.newOrder;
  }

  @override
  set newOrder(bool value) {
    _$newOrderAtom.reportWrite(value, super.newOrder, () {
      super.newOrder = value;
    });
  }

  late final _$selectedClientAtom = Atom(
      name: '_OrderRegistrationControllerBase.selectedClient',
      context: context);

  @override
  Client? get selectedClient {
    _$selectedClientAtom.reportRead();
    return super.selectedClient;
  }

  @override
  set selectedClient(Client? value) {
    _$selectedClientAtom.reportWrite(value, super.selectedClient, () {
      super.selectedClient = value;
    });
  }

  late final _$newOrderDataAtom = Atom(
      name: '_OrderRegistrationControllerBase.newOrderData', context: context);

  @override
  OrderModel? get newOrderData {
    _$newOrderDataAtom.reportRead();
    return super.newOrderData;
  }

  @override
  set newOrderData(OrderModel? value) {
    _$newOrderDataAtom.reportWrite(value, super.newOrderData, () {
      super.newOrderData = value;
    });
  }

  late final _$selectedProductAtom = Atom(
      name: '_OrderRegistrationControllerBase.selectedProduct',
      context: context);

  @override
  Product? get selectedProduct {
    _$selectedProductAtom.reportRead();
    return super.selectedProduct;
  }

  @override
  set selectedProduct(Product? value) {
    _$selectedProductAtom.reportWrite(value, super.selectedProduct, () {
      super.selectedProduct = value;
    });
  }

  late final _$selectedOrderItemAtom = Atom(
      name: '_OrderRegistrationControllerBase.selectedOrderItem',
      context: context);

  @override
  OrderItem? get selectedOrderItem {
    _$selectedOrderItemAtom.reportRead();
    return super.selectedOrderItem;
  }

  @override
  set selectedOrderItem(OrderItem? value) {
    _$selectedOrderItemAtom.reportWrite(value, super.selectedOrderItem, () {
      super.selectedOrderItem = value;
    });
  }

  late final _$orderItemListAtom = Atom(
      name: '_OrderRegistrationControllerBase.orderItemList', context: context);

  @override
  ObservableList<OrderItem> get orderItemList {
    _$orderItemListAtom.reportRead();
    return super.orderItemList;
  }

  @override
  set orderItemList(ObservableList<OrderItem> value) {
    _$orderItemListAtom.reportWrite(value, super.orderItemList, () {
      super.orderItemList = value;
    });
  }

  late final _$productListAtom = Atom(
      name: '_OrderRegistrationControllerBase.productList', context: context);

  @override
  ObservableList<Product> get productList {
    _$productListAtom.reportRead();
    return super.productList;
  }

  @override
  set productList(ObservableList<Product> value) {
    _$productListAtom.reportWrite(value, super.productList, () {
      super.productList = value;
    });
  }

  late final _$clientListAtom = Atom(
      name: '_OrderRegistrationControllerBase.clientList', context: context);

  @override
  ObservableList<Client> get clientList {
    _$clientListAtom.reportRead();
    return super.clientList;
  }

  @override
  set clientList(ObservableList<Client> value) {
    _$clientListAtom.reportWrite(value, super.clientList, () {
      super.clientList = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_OrderRegistrationControllerBase.error', context: context);

  @override
  Option<OrderError> get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Option<OrderError> value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$callEntitySelectionDialogAsyncAction = AsyncAction(
      '_OrderRegistrationControllerBase.callEntitySelectionDialog',
      context: context);

  @override
  Future callEntitySelectionDialog(BuildContext context) {
    return _$callEntitySelectionDialogAsyncAction
        .run(() => super.callEntitySelectionDialog(context));
  }

  late final _$callAddNoteDialogAsyncAction = AsyncAction(
      '_OrderRegistrationControllerBase.callAddNoteDialog',
      context: context);

  @override
  Future callAddNoteDialog(BuildContext context) {
    return _$callAddNoteDialogAsyncAction
        .run(() => super.callAddNoteDialog(context));
  }

  late final _$_OrderRegistrationControllerBaseActionController =
      ActionController(
          name: '_OrderRegistrationControllerBase', context: context);

  @override
  dynamic initState(
      {required o.Order? order,
      required List<Product> productList,
      required List<Client> clientList}) {
    final _$actionInfo = _$_OrderRegistrationControllerBaseActionController
        .startAction(name: '_OrderRegistrationControllerBase.initState');
    try {
      return super.initState(
          order: order, productList: productList, clientList: clientList);
    } finally {
      _$_OrderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectProduct(Product product) {
    final _$actionInfo = _$_OrderRegistrationControllerBaseActionController
        .startAction(name: '_OrderRegistrationControllerBase.selectProduct');
    try {
      return super.selectProduct(product);
    } finally {
      _$_OrderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectClient(Client client) {
    final _$actionInfo = _$_OrderRegistrationControllerBaseActionController
        .startAction(name: '_OrderRegistrationControllerBase.selectClient');
    try {
      return super.selectClient(client);
    } finally {
      _$_OrderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic addSelectedOrderItemToList() {
    final _$actionInfo =
        _$_OrderRegistrationControllerBaseActionController.startAction(
            name:
                '_OrderRegistrationControllerBase.addSelectedOrderItemToList');
    try {
      return super.addSelectedOrderItemToList();
    } finally {
      _$_OrderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic initOrderItem() {
    final _$actionInfo = _$_OrderRegistrationControllerBaseActionController
        .startAction(name: '_OrderRegistrationControllerBase.initOrderItem');
    try {
      return super.initOrderItem();
    } finally {
      _$_OrderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic prepareToSelectNewProduct() {
    final _$actionInfo =
        _$_OrderRegistrationControllerBaseActionController.startAction(
            name: '_OrderRegistrationControllerBase.prepareToSelectNewProduct');
    try {
      return super.prepareToSelectNewProduct();
    } finally {
      _$_OrderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeItemFromOrderItemList(OrderItem item) {
    final _$actionInfo =
        _$_OrderRegistrationControllerBaseActionController.startAction(
            name:
                '_OrderRegistrationControllerBase.removeItemFromOrderItemList');
    try {
      return super.removeItemFromOrderItemList(item);
    } finally {
      _$_OrderRegistrationControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
newOrder: ${newOrder},
selectedClient: ${selectedClient},
newOrderData: ${newOrderData},
selectedProduct: ${selectedProduct},
selectedOrderItem: ${selectedOrderItem},
orderItemList: ${orderItemList},
productList: ${productList},
clientList: ${clientList},
error: ${error}
    ''';
  }
}
