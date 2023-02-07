import 'package:controle_pedidos/src/domain/entities/order.dart' as o;
import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/domain/repositories/i_order_repository.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/order/errors/order_error.dart';
import 'package:dartz/dartz.dart';

class OrderUsecaseImpl implements IOrderUsecase {
  final IOrderRepository _repository;

  OrderUsecaseImpl(this._repository);

  @override
  Future<Either<OrderError, o.Order>> createOrder(o.Order order) async {
    if (order.orderItemList.isEmpty) {
      return Left(OrderError('Order Item List cannot be empty'));
    }

    if (order.client.id.isEmpty) {
      return Left(OrderError('Client ID cannot be empty'));
    }

    if (order.enabled == false) {
      return Left(OrderError('Order enabled already is false'));
    }

    return _repository.createOrder(order);
  }

  @override
  Future<Either<OrderError, o.Order>> updateOrder(o.Order order) async {
    if (order.id.isEmpty) {
      return Left(OrderError('Order ID cannot be empty'));
    }

    if (order.orderItemList.isEmpty) {
      return Left(OrderError('Order Item List cannot be empty'));
    }

    if (order.client.id.isEmpty) {
      return Left(OrderError('Client ID cannot be empty'));
    }

    if (order.enabled == false) {
      return Left(OrderError('Order enabled already is false'));
    }

    return _repository.updateOrder(order);
  }

  @override
  Future<Either<OrderError, bool>> disableOrder(o.Order order) async {
    if (order.id.isEmpty) {
      return Left(OrderError('Order ID cannot be empty'));
    }

    return _repository.disableOrder(order);
  }

  @override
  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabled() {
    return _repository.getOrderListByEnabled();
  }

  @override
  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabledAndDate(
      DateTime date) {
    return _repository.getOrderListByEnabledAndDate(date);
  }

  @override
  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate) {
    return _repository.getOrderListByEnabledBetweenDates(iniDate, endDate);
  }

  @override
  Future<Either<OrderError, List<o.Order>>>
      getOrderListByEnabledAndProductAndDate(
          Product product, DateTime iniDate, DateTime endDate) async {
    if (product.id.isEmpty) {
      return Left(OrderError('Invalid product ID'));
    }

    return _repository.getOrderListByEnabledAndProductAndDate(
        product, iniDate, endDate);
  }
}
