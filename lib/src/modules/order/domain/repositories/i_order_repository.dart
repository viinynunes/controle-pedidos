import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/errors/order_info_exception.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/entities/order.dart' as o;

abstract class IOrderRepository {
  Future<Either<OrderInfoException, o.Order>> createOrder(o.Order order);

  Future<Either<OrderInfoException, o.Order>> updateOrder(o.Order order);

  Future<Either<OrderInfoException, bool>> disableOrder(o.Order order);

  Future<Either<OrderInfoException, List<o.Order>>> getOrderListByEnabled();

  Future<Either<OrderInfoException, List<o.Order>>> getOrderListByEnabledAndDate(
      DateTime date);

  Future<Either<OrderInfoException, List<o.Order>>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate);

  Future<Either<OrderInfoException, List<o.Order>>> getOrderListByEnabledAndProductAndDate(
      Product product, DateTime iniDate, DateTime endDate);
}
