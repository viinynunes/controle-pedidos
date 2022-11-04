import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/errors/order_error.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/entities/order.dart' as o;

abstract class IOrderUsecase {
  Future<Either<OrderError, o.Order>> createOrder(o.Order order);

  Future<Either<OrderError, o.Order>> updateOrder(o.Order order);

  Future<Either<OrderError, bool>> disableOrder(o.Order order);

  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabled();

  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabledAndDate(
      DateTime date);

  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate);

  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabledAndProduct(
      Product product);
}
