import '../../../../domain/models/order_model.dart';
import '../../../../domain/models/product_model.dart';

abstract class IOrderDatasource {
  Future<OrderModel> createOrder(OrderModel order);

  Future<OrderModel> updateOrder(OrderModel order);

  Future<bool> disableOrder(OrderModel order);

  Future<List<OrderModel>> getOrderListByEnabled();

  Future<List<OrderModel>> getOrderListByEnabledAndDate(DateTime date);

  Future<List<OrderModel>> getOrderListByEnabledBetweenDates(
      DateTime iniDate, DateTime endDate);

  Future<List<OrderModel>> getOrderListByEnabledAndProduct(
      ProductModel product);
}
