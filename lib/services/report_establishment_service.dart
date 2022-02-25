import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:flutter/material.dart';

class ReportEstablishmentService {
  Future<List<OrderItemData>> mergeOrderItemsByProvider(
      BuildContext context, DateTime iniDate, DateTime endDate) async {
    List<OrderItemData> orderItemList = [];

    final orderList = await OrderModel.of(context)
        .getEnabledOrdersBetweenDates(iniDate, endDate);

    for (var order in orderList) {
      for (var item in order.orderItemList!) {
        if (orderItemList.contains(item)) {
          var listItem =
              orderItemList.singleWhere((element) => element == item);
          item.quantity += listItem.quantity;
          orderItemList.remove(listItem);
        }
        orderItemList.add(item);
      }
    }

    orderItemList.sort((a, b) {
      int compare = a.product.provider.name.toLowerCase().compareTo(b.product.provider.name.toLowerCase());

      if (compare == 0){
        return a.product.name.toLowerCase().compareTo(b.product.name.toLowerCase());
      }else {
        return compare;
      }
    });

    return orderItemList;
  }
}
