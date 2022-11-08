import 'package:controle_pedidos/src/domain/entities/order.dart';

import '../i_order_service.dart';

class OrderServiceImpl implements IOrderService {
  @override
  void sortOrderListByRegistrationHour(List<Order> orderList) {
    orderList
        .sort((a, b) => b.registrationHour.compareTo(a.registrationHour));
  }
}
