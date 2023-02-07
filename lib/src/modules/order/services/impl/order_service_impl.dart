import 'package:controle_pedidos/src/domain/entities/order.dart' as o;
import 'package:controle_pedidos/src/domain/entities/order_item.dart';
import 'package:controle_pedidos/src/modules/order/errors/order_error.dart';
import 'package:dartz/dartz.dart';

import '../i_order_service.dart';

class OrderServiceImpl implements IOrderService {
  @override
  void sortOrderListByRegistrationHour(List<o.Order> orderList) {
    orderList.sort((a, b) => b.registrationHour.compareTo(a.registrationHour));

    for (var o in orderList) {
      sortOrderItems(o.orderItemList);
    }
  }

  @override
  void sortOrderListByClientName(List<o.Order> orderList) {
    orderList.sort((a, b) {
      final compare =
          a.client.name.toLowerCase().compareTo(b.client.name.toLowerCase());

      if (compare == 0) {
        return a.registrationHour.compareTo(b.registrationHour);
      }
      return compare;
    });

    for (var o in orderList) {
      sortOrderItems(o.orderItemList);
    }
  }

  @override
  Either<OrderError, List<o.Order>> mergeOrderListByClient(
      List<o.Order> orderList) {
    List<o.Order> mergedList = [];
    o.Order? previousOrder;

    sortOrderListByClientName(orderList);

    for (var actualOrder in orderList) {
      if (previousOrder != actualOrder) {
        sortOrderItems(actualOrder.orderItemList);
        mergedList.add(actualOrder);
        previousOrder = actualOrder;
      } else {
        for (var actualItem in actualOrder.orderItemList) {
          if (previousOrder != null &&
              !previousOrder.orderItemList.contains(actualItem)) {
            previousOrder.orderItemList.add(actualItem);
          } else {
            try {
              var previousItem = previousOrder!.orderItemList
                  .singleWhere((element) => element == actualItem);

              if (previousItem.note.isNotEmpty && actualItem.note.isNotEmpty) {
                previousOrder.orderItemList.add(actualItem);
              }

              if (previousItem.note.isEmpty && actualItem.note.isEmpty) {
                previousItem.quantity += actualItem.quantity;
              }

              if (previousItem.note.isEmpty && actualItem.note.isNotEmpty ||
                  previousItem.note.isNotEmpty && actualItem.note.isEmpty) {
                previousItem.quantity += actualItem.quantity;
                previousItem.note = actualItem.note;
              }
            } on StateError {
              return Left(OrderError('Mais de um item encontrado'));
            } catch (e) {
              return Left(OrderError(e.toString()));
            }
          }
        }
      }

      sortOrderItems(actualOrder.orderItemList);
    }

    return Right(mergedList);
  }

  void sortOrderItems(List<OrderItem> orderItemList) {
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
