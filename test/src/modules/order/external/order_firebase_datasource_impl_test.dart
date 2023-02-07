import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/order_model.dart';
import 'package:controle_pedidos/src/modules/order/external/order_firebase_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../domain/entities/client_mock.dart';
import '../../../domain/entities/order_item_mock.dart';
import '../../../domain/entities/order_mock.dart';

main() {
  late FirebaseFirestore? firebase;
  late IOrderDatasource datasource;
  late CollectionReference? orderCollection;

  const mockCompanyID = 'mockCompanyID';

  setUp(() async {
    firebase = null;
    firebase = FakeFirebaseFirestore();
    orderCollection = null;

    orderCollection =
        firebase!.collection('company').doc(mockCompanyID).collection('order');

    datasource = OrderFirebaseDatasourceImpl(
        firebase: firebase!,
        companyID: mockCompanyID);
  });

  group('create order tests', () {
    test('create new order into firebase', () async {
      final result = await datasource.createOrder(OrderMock.getOneOrder());

      final docRef = await orderCollection!.doc(result.id).get();

      expect(result, isA<OrderModel>());
      expect(result.id, isA<String>());
      expect(result.orderItemList.length, equals(2));
      expect(docRef.id, equals(result.id));
    });
/*

    test('verify if stock was created after the new order', () async {
      final createdOrder = await datasource.createOrder(OrderMock.getOneOrder(
          orderItemList: OrderItemMock.getOrderItemList(elements: 4)));

      ///verify if stock was created successfully
      for (var i in createdOrder.orderItemList) {
        final stockCode = StockMock.getStockCodeFromProduct(
            product: i.product, date: createdOrder.registrationDate);
        final stockByCodeRef =
            await stockCollection!.where('code', isEqualTo: stockCode).get();

        expect(stockByCodeRef.docs.length, 1);

        final stock =
            StockModel.fromDocumentSnapshot(stockByCodeRef.docs.first);

        expect(stock.code, stockCode);
        expect(stock.product.id, i.product.id);
        expect(stock.total, i.quantity);
      }
    });
*/
/*
    test('verify if stock the sum stock total when create more orders',
        () async {
      const loopTimes = 45;
      late OrderModel order;

      for (int i = 0; i < loopTimes; i++) {
        order = await datasource.createOrder(OrderMock.getOneOrder());
      }

      ///verify if the stock was created successfully and if stock total was summed for each order item
      for (var i in order.orderItemList) {
        final stockCode = StockMock.getStockCodeFromProduct(
            product: i.product, date: order.registrationDate);

        final stockRef =
            await stockCollection!.where('code', isEqualTo: stockCode).get();

        final stock = StockModel.fromDocumentSnapshot(stockRef.docs.first);

        expect(i.quantity * loopTimes, stock.total);
      }
    });*/
  });

  group('update order tests', () {
    test('have to update order data from DB', () async {
      var order = OrderMock.getOneOrder();

      final orderOnDB = await datasource.createOrder(order);

      order.client = ClientMock.getOneClient(name: 'Jose');

      final updatedOrder = await datasource.updateOrder(order);

      expect(orderOnDB.id, updatedOrder.id);
      expect(updatedOrder.client.name, 'Jose');
      expect(updatedOrder.registrationDate, equals(orderOnDB.registrationDate));
      expect(updatedOrder.registrationHour, equals(orderOnDB.registrationHour));
    });

    test(
        'have to remove all order items from previous order and add new order items',
        () async {
      var toModifyOrder = OrderMock.getOneOrder();

      final orderOnDB = await datasource.createOrder(toModifyOrder);

      toModifyOrder.client = ClientMock.getOneClient(name: 'Cleusa');

      int orderItemListLength = 4;

      toModifyOrder.orderItemList = OrderItemMock.getOrderItemList(
          elements: orderItemListLength, modifyProductID: true);

      final updatedOrder = await datasource.updateOrder(toModifyOrder);

      expect(orderOnDB.id, updatedOrder.id);
      expect(updatedOrder.client.name, 'Cleusa');
      expect(updatedOrder.registrationDate, equals(orderOnDB.registrationDate));
      expect(updatedOrder.registrationHour, equals(orderOnDB.registrationHour));
      expect(updatedOrder.orderItemList.length, orderItemListLength);
    });
/*

    test(
        'have to modify order item list and keep stock collection equals data from order item list data',
        () async {
      var toModifyOrder = OrderMock.getOneOrder();

      ///creating order with 2 order items on list / 3 p1 - 6 p2
      await datasource.createOrder(toModifyOrder);

      int orderItemListLength = 2;

      ///modify orderItem list to only 1 item / 3 p10
      toModifyOrder.orderItemList = OrderItemMock.getOrderItemList(
          elements: orderItemListLength, modifyProductID: true);

      await datasource.updateOrder(toModifyOrder);

      for (var i in toModifyOrder.orderItemList) {
        final stockCode = StockMock.getStockCodeFromProduct(
            product: i.product, date: toModifyOrder.registrationDate);
        final stockByCodeRef =
            await stockCollection!.where('code', isEqualTo: stockCode).get();

        expect(stockByCodeRef.docs.length, 1);

        final stock =
            StockModel.fromDocumentSnapshot(stockByCodeRef.docs.first);

        expect(stock.code, stockCode);
        expect(stock.product.id, i.product.id);
        expect(stock.total, i.quantity);
      }

      ///check if total stock collection have the same quantity of order items
      final stockRef = await stockCollection!.get();

      expect(stockRef.docs.length, orderItemListLength);
    });
*/
/*
    test('have to increase order item list keeping stock collection', () async {
      var toModifyOrder = OrderMock.getOneOrder();

      ///creating order with 2 order items on list / 3 p1 - 6 p2
      await datasource.createOrder(toModifyOrder);

      ///modify orderItem list to only 1 item / 3 p10
      toModifyOrder.orderItemList
          .add(OrderItemMock.getOneOrderItem(productID: 'newProductID'));

      final updatedOrder = await datasource.updateOrder(toModifyOrder);

      for (var i in toModifyOrder.orderItemList) {
        final stockCode = StockMock.getStockCodeFromProduct(
            product: i.product, date: toModifyOrder.registrationDate);
        final stockByCodeRef =
            await stockCollection!.where('code', isEqualTo: stockCode).get();

        expect(stockByCodeRef.docs.length, 1);

        final stock =
            StockModel.fromDocumentSnapshot(stockByCodeRef.docs.first);

        expect(stock.code, stockCode);
        expect(stock.product.id, i.product.id);
        expect(stock.total, i.quantity);
      }

      final stockRef = await stockCollection!.get();

      expect(stockRef.docs.length, updatedOrder.orderItemList.length);
    });*/
/*

    test(
        'have to remove an order item from order and modify stock collection as order item list',
        () async {
      var toModifyOrder = OrderMock.getOneOrder(
          orderItemList: OrderItemMock.getOrderItemList(elements: 5));

      ///creating order with 2 order items on list / 3 p1 - 6 p2 - 9 p3 - 12 -p4 - 15 p5
      await datasource.createOrder(toModifyOrder);

      ///modify orderItem list removing p1 and p4
      toModifyOrder.orderItemList.removeAt(0);
      toModifyOrder.orderItemList.removeAt(2);

      final updatedOrder = await datasource.updateOrder(toModifyOrder);

      for (var i in toModifyOrder.orderItemList) {
        final stockCode = StockMock.getStockCodeFromProduct(
            product: i.product, date: toModifyOrder.registrationDate);
        final stockByCodeRef =
            await stockCollection!.where('code', isEqualTo: stockCode).get();

        expect(stockByCodeRef.docs.length, 1);

        final stock =
            StockModel.fromDocumentSnapshot(stockByCodeRef.docs.first);

        expect(stock.code, stockCode);
        expect(stock.product.id, i.product.id);
        expect(stock.total, i.quantity);
      }

      final stockRef = await stockCollection!.get();
      expect(stockRef.docs.length, updatedOrder.orderItemList.length);
    });
*/
/*

    test(
        'have to add new order item and remove order item and keep stock as order item list',
        () async {
      var toModifyOrder = OrderMock.getOneOrder(
          orderItemList: OrderItemMock.getOrderItemList(elements: 5));

      ///creating order with 2 order items on list / 3 p1 - 6 p2 - 9 p3 - 12 -p4 - 15 p5
      await datasource.createOrder(toModifyOrder);

      ///modify orderItem list removing p1 and p4
      toModifyOrder.orderItemList.removeAt(1);
      toModifyOrder.orderItemList.removeAt(2);
      toModifyOrder.orderItemList.removeAt(0);

      toModifyOrder.orderItemList.add(OrderItemMock.getOneOrderItem(
          productID: 'added Product ID 01', productName: 'added product 01'));

      toModifyOrder.orderItemList.add(OrderItemMock.getOneOrderItem(
          productID: 'added Product ID 02', productName: 'added product 02'));

      toModifyOrder.orderItemList.add(OrderItemMock.getOneOrderItem(
          productID: 'added Product ID 03', productName: 'added product 03'));

      toModifyOrder.orderItemList.add(OrderItemMock.getOneOrderItem(
          productID: 'added Product ID 04', productName: 'added product 04'));

      final updatedOrder = await datasource.updateOrder(toModifyOrder);

      for (var i in toModifyOrder.orderItemList) {
        final stockCode = StockMock.getStockCodeFromProduct(
            product: i.product, date: toModifyOrder.registrationDate);
        final stockByCodeRef =
            await stockCollection!.where('code', isEqualTo: stockCode).get();

        expect(stockByCodeRef.docs.length, 1);

        final stock =
            StockModel.fromDocumentSnapshot(stockByCodeRef.docs.first);

        expect(stock.code, stockCode);
        expect(stock.product.id, i.product.id);
        expect(stock.total, i.quantity);
      }

      final stockRef = await stockCollection!.get();
      expect(stockRef.docs.length, updatedOrder.orderItemList.length);
    });
*/
/*
    test(
        'have to update order but when stock total is not zero, keep stock data',
        () async {
      const quantityOrders = 3;

      ///HAVE TO BE MORE THEN 2
      const orderItemListElements = 4;

      final unmodifiedOrder = OrderMock.getOneOrder(
          orderItemList:
              OrderItemMock.getOrderItemList(elements: orderItemListElements));
      late OrderModel lastAddedOrder;
      for (int i = 1; i <= quantityOrders; i++) {
        if (i == 1) {
          await datasource.createOrder(unmodifiedOrder);
        } else {
          lastAddedOrder = await datasource.createOrder(OrderMock.getOneOrder(
              orderItemList: OrderItemMock.getOrderItemList(
                  elements: orderItemListElements)));
        }
      }

      String removedProductID = 'productID-$orderItemListElements';

      final removedElement = lastAddedOrder.orderItemList
          .singleWhere((element) => element.product.id == removedProductID);
      lastAddedOrder.orderItemList.remove(removedElement);

      await datasource.updateOrder(lastAddedOrder);

      for (int i = 1; i <= unmodifiedOrder.orderItemList.length; i++) {
        final item = unmodifiedOrder.orderItemList[i - 1];

        int total = 0;

        if (item == removedElement) {
          total = item.quantity * (quantityOrders - 1);
        } else {
          total = item.quantity * quantityOrders;
        }

        final stockCode = StockMock.getStockCodeFromProduct(
            product: item.product, date: unmodifiedOrder.registrationDate);
        final stockByCodeRef =
            await stockCollection!.where('code', isEqualTo: stockCode).get();

        expect(stockByCodeRef.docs.length, 1);

        final stock =
            StockModel.fromDocumentSnapshot(stockByCodeRef.docs.first);

        expect(stock.total, total);
      }
    });*/
  });

  group('Disable order tests', () {
    /*test('have to disable an order and delete his stock', () async {
      final order = await datasource.createOrder(OrderMock.getOneOrder());

      final disableResult = await datasource.disableOrder(order);

      expect(disableResult, true);

      final orderSnap = await orderCollection!.doc(order.id).get();

      expect(orderSnap.exists, true);

      final disabledOrder = OrderModel.fromDocumentSnapshot(doc: orderSnap);
      expect(disabledOrder.enabled, false);

      for (var item in disabledOrder.orderItemList) {
        final stockSnap = await stockCollection!
            .where('code',
                isEqualTo: StockMock.getStockCodeFromProduct(
                    product: item.product, date: DateTime.now()))
            .get();

        expect(stockSnap.docs.length, 0);
      }
    });

    test(
        'have to disable an order and dont delete his stock when stock total is not empty',
        () async {
      const totalOrders = 7;
      late OrderModel toDisableOrder;

      for (int i = 1; i <= totalOrders; i++) {
        toDisableOrder = await datasource.createOrder(OrderMock.getOneOrder());
      }
      for (var item in toDisableOrder.orderItemList) {
        final stockSnap = await stockCollection!
            .where('code',
                isEqualTo: StockMock.getStockCodeFromProduct(
                    product: item.product, date: DateTime.now()))
            .get();

        expect(stockSnap.docs.length, 1);

        final stock = StockModel.fromDocumentSnapshot(stockSnap.docs.first);

        expect(stock.total, item.quantity * totalOrders);
      }

      await datasource.disableOrder(toDisableOrder);

      final orderSnap = await orderCollection!.doc(toDisableOrder.id).get();

      final disabledOrder = OrderModel.fromDocumentSnapshot(doc: orderSnap);

      for (var item in disabledOrder.orderItemList) {
        final stockSnap = await stockCollection!
            .where('code',
                isEqualTo: StockMock.getStockCodeFromProduct(
                    product: item.product, date: DateTime.now()))
            .get();

        expect(stockSnap.docs.length, 1);
        final stock = StockModel.fromDocumentSnapshot(stockSnap.docs.first);

        expect(stock.total, (item.quantity * totalOrders) - item.quantity);
      }
    });*/
  });
}
