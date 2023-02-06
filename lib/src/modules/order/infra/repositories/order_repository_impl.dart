import 'package:controle_pedidos/src/core/date_time_helper.dart';
import 'package:controle_pedidos/src/domain/entities/order.dart' as o;
import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/domain/models/order_item_model.dart';
import 'package:controle_pedidos/src/modules/order/domain/repositories/i_order_repository.dart';
import 'package:controle_pedidos/src/modules/order/errors/order_error.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/models/order_model.dart';

class OrderRepositoryImpl implements IOrderRepository {
  final IOrderDatasource _datasource;

  OrderRepositoryImpl(this._datasource);

  @override
  Future<Either<OrderError, o.Order>> createOrder(o.Order order) async {
    try {
      order.registrationDate =
          DateTimeHelper.removeHourFromDateTime(date: order.registrationDate);

      final result =
          await _datasource.createOrder(OrderModel.fromOrder(order: order));

      return Right(result);
    } catch (e) {
      return Left(OrderError(e.toString()));
    }
  }

  @override
  Future<Either<OrderError, o.Order>> updateOrder(o.Order order) async {
    try {
      final result =
          await _datasource.updateOrder(OrderModel.fromOrder(order: order));

      return Right(result);
    } catch (e) {
      return Left(OrderError(e.toString()));
    }
  }

  @override
  Future<Either<OrderError, bool>> disableOrder(o.Order order) async {
    try {
      final result =
          await _datasource.disableOrder(OrderModel.fromOrder(order: order));

      return Right(result);
    } catch (e) {
      return Left(OrderError(e.toString()));
    }
  }

  @override
  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabled() async {
    try {
      final result = await _datasource.getOrderListByEnabled();

      return Right(result);
    } catch (e) {
      return Left(OrderError(e.toString()));
    }
  }

  @override
  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabledAndDate(
      DateTime date) async {
    try {
      date = DateTimeHelper.removeHourFromDateTime(date: date);

      final result = await _datasource.getOrderListByEnabledAndDate(date);

      return Right(result);
    } catch (e) {
      return Left(OrderError(e.toString()));
    }
  }

  @override
  Future<Either<OrderError, List<o.Order>>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    try {
      iniDate = DateTimeHelper.removeHourFromDateTime(date: iniDate);
      endDate = DateTimeHelper.removeHourFromDateTime(date: endDate);

      final result =
          await _datasource.getOrderListByEnabledBetweenDates(iniDate, endDate);

      return Right(result);
    } catch (e) {
      return Left(OrderError(e.toString()));
    }
  }

  @override
  Future<Either<OrderError, List<o.Order>>>
      getOrderListByEnabledAndProductAndDate(
          Product product, DateTime iniDate, DateTime endDate) async {
    try {
      iniDate = DateTimeHelper.removeHourFromDateTime(date: iniDate);
      endDate = DateTimeHelper.removeHourFromDateTime(date: endDate);

      List<OrderModel> orderList =
          await _datasource.getOrderListByEnabledBetweenDates(iniDate, endDate);

      final orderItem =
          OrderItemModel(listIndex: 0, quantity: 0, product: product, note: '');

      List<OrderModel> filteredOrderList = orderList
          .where((element) => element.orderItemList.contains(orderItem))
          .toList();

      for (var o in filteredOrderList) {
        o.orderItemList.removeWhere((element) => element != orderItem);

        if (o.orderItemList.length != 1) {
          throw Exception('Erro ao remover order items from list');
        }
      }

      return Right(filteredOrderList);
    } catch (e) {
      return Left(OrderError(e.toString()));
    }
  }
}
