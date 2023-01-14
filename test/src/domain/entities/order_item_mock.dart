import 'package:controle_pedidos/src/domain/models/order_item_model.dart';

import 'product_mock.dart';

class OrderItemMock {
  static OrderItemModel getOneOrderItem({
    int index = 0,
    String productID = 'product01',
    String productName = 'product name 001',
    int quantity = 10,
    String note = '',
  }) {
    return OrderItemModel(
        listIndex: index,
        quantity: quantity,
        product:
            ProductMock.getOneProduct(productID: productID, name: productName),
        note: note);
  }

  static List<OrderItemModel> getOrderItemList(
      {int elements = 2, bool modifyProductID = false}) {
    List<OrderItemModel> orderItemList = [];

    for (int i = 1; i <= elements; i++) {
      final orderItem = OrderItemModel(
          listIndex: i,
          quantity: i * 3,
          product: ProductMock.getOneProduct(
              productID: 'productID-${modifyProductID ? i * 10 : i}',
              name: 'product name ${modifyProductID ? i * 10 : i}'),
          note: '');

      orderItemList.add(orderItem);
    }

    return orderItemList;
  }
}
