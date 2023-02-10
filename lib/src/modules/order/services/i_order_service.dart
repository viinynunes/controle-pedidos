import 'package:controle_pedidos/src/domain/entities/order.dart'as o;
import 'package:controle_pedidos/src/modules/order/errors/order_info_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IOrderService {
  void sortOrderListByRegistrationHour(List<o.Order> orderList);

  void sortOrderListByClientName(List<o.Order> orderList);

  Either<OrderInfoException, List<o.Order>> mergeOrderListByClient(List<o.Order> orderList);
}
