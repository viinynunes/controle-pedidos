import 'package:controle_pedidos/data/order_data.dart';

import '../data/order_item_data.dart';

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
            if (equal.note == null && item.note == null ||
                item.note != null && equal.note == null) {
              item.quantity += equal.quantity;
              previousOrder.orderItemList!.remove(equal);
              previousOrder.orderItemList!.add(item);
            } else if (equal.note != null && item.note == null) {
              equal.quantity += item.quantity;
              previousOrder.orderItemList!.remove(equal);
              previousOrder.orderItemList!.add(equal);
            } else if (equal.note != null && item.note != null) {
              previousOrder.orderItemList!.add(item);
            }
          } else {
            previousOrder.orderItemList!.add(item);
          }

          newOrderList.remove(previousOrder);
          sortOrderItems(previousOrder.orderItemList!);
          newOrderList.add(previousOrder);
        }
      } else {
        sortOrderItems(order.orderItemList!);
        newOrderList.add(order);
        previousOrder = order;
      }
    }

    return newOrderList;
  }

  void sortByDate(List<OrderData> orderList) {
    orderList.sort((a, b) => a.creationHour.compareTo(b.creationHour));
  }

  void sortOrderItems(List<OrderItemData> orderItemList) {
    orderItemList.sort((a, b) {
      int compare = a.product.category
          .toLowerCase()
          .compareTo(b.product.category.toLowerCase());

      if (compare == 0) {
        var name1 = a.product.name.toLowerCase();
        var name2 = b.product.name.toLowerCase();

        return name1.compareTo(name2);
      } else {
        return compare;
      }
    });
  }
}
