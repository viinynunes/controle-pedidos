import 'package:controle_pedidos/src/domain/entities/order.dart' as o;
import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/order/domain/repositories/i_order_repository.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/order/errors/order_info_exception.dart';
import 'package:dartz/dartz.dart';

class OrderUsecaseImpl implements IOrderUsecase {
  final IOrderRepository _repository;

  OrderUsecaseImpl(this._repository);

  @override
  Future<Either<OrderInfoException, o.Order>> createOrder(o.Order order) async {
    if (order.orderItemList.isEmpty) {
      return Left(OrderInfoException('A lista de itens não pode ser vazia'));
    }

    if (order.client.id.isEmpty) {
      return Left(OrderInfoException('O ID do cliente não pode estar vazio'));
    }

    if (order.enabled == false) {
      return Left(OrderInfoException('Pedido está desativado'));
    }

    return _repository.createOrder(order);
  }

  @override
  Future<Either<OrderInfoException, o.Order>> updateOrder(o.Order order) async {
    if (order.id.isEmpty) {
      return Left(OrderInfoException('O ID do pedido não pode estar vazio'));
    }

    if (order.orderItemList.isEmpty) {
      return Left(OrderInfoException('A lista de itens não pode estar vazio'));
    }

    if (order.client.id.isEmpty) {
      return Left(OrderInfoException('O ID do cliente não pode estar vazio'));
    }

    if (order.enabled == false) {
      return Left(OrderInfoException('Pedido está desativado'));
    }

    return _repository.updateOrder(order);
  }

  @override
  Future<Either<OrderInfoException, bool>> disableOrder(o.Order order) async {
    if (order.id.isEmpty) {
      return Left(OrderInfoException('O ID do pedido não pode estar vazio'));
    }

    return _repository.disableOrder(order);
  }

  @override
  Future<Either<OrderInfoException, List<o.Order>>> getOrderListByEnabled() {
    return _repository.getOrderListByEnabled();
  }

  @override
  Future<Either<OrderInfoException, List<o.Order>>> getOrderListByEnabledAndDate(
      DateTime date) {
    return _repository.getOrderListByEnabledAndDate(date);
  }

  @override
  Future<Either<OrderInfoException, List<o.Order>>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate) {
    return _repository.getOrderListByEnabledBetweenDates(iniDate, endDate);
  }

  @override
  Future<Either<OrderInfoException, List<o.Order>>>
      getOrderListByEnabledAndProductAndDate(
          Product product, DateTime iniDate, DateTime endDate) async {
    if (product.id.isEmpty) {
      return Left(OrderInfoException('O ID do produto não pode estar vazio'));
    }

    return _repository.getOrderListByEnabledAndProductAndDate(
        product, iniDate, endDate);
  }
}
