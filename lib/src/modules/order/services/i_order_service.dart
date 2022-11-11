import 'package:controle_pedidos/src/domain/entities/order.dart';

abstract class IOrderService {
  void sortOrderListByRegistrationHour(List<Order> orderList);

  void sortOrderListByClientName(List<Order> orderList);
}
