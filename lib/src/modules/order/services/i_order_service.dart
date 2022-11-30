import 'package:controle_pedidos/src/domain/entities/order.dart'as o;
import 'package:controle_pedidos/src/modules/order/errors/order_error.dart';
import 'package:dartz/dartz.dart';

abstract class IOrderService {
  void sortOrderListByRegistrationHour(List<o.Order> orderList);

  void sortOrderListByClientName(List<o.Order> orderList);

  Either<OrderError, List<o.Order>> mergeOrderListByClient(List<o.Order> orderList);
}
