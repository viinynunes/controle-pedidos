import 'package:controle_pedidos/data/order_data.dart';

class OrderServices {
  List<OrderData> mergeOrdersBetweenDifferentDates(List<OrderData> orderList) {
    List<OrderData> newOrderList = [];
    OrderData? previousOrder;

    for (var order in orderList) {
      if (previousOrder != null && order == previousOrder) {
        for (var item in order.orderItemList!) {
          if (previousOrder.orderItemList!.contains(item)) {
            var equal = previousOrder.orderItemList!.singleWhere(
                (element) => element.product.id == item.product.id);
            item.quantity += equal.quantity;
            previousOrder.orderItemList!.remove(equal);

          }
          previousOrder.orderItemList!.add(item);
          newOrderList.remove(previousOrder);
          newOrderList.add(previousOrder);
        }
      } else {
        newOrderList.add(order);
        previousOrder = order;
      }
    }

    return newOrderList;
  }
}
