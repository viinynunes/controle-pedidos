import 'package:controle_pedidos/src/modules/order/domain/repositories/i_order_repository.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/i_order_usecase.dart';
import 'package:controle_pedidos/src/modules/order/domain/usecase/impl/order_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/order/external/order_firebase_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/order/infra/datasources/i_order_datasource.dart';
import 'package:controle_pedidos/src/modules/order/infra/repositories/order_repository_impl.dart';
import 'package:controle_pedidos/src/modules/order/presenter/stores/order_controller.dart';
import 'package:controle_pedidos/src/modules/order/presenter/stores/order_registration_controller.dart';
import 'package:get_it/get_it.dart';

import 'presenter/stores/order_report_controller.dart';
import 'services/i_order_service.dart';
import 'services/impl/order_service_impl.dart';

final orderLocator = GetIt.instance;

Future<void> setUpOrderLocator() async {
  orderLocator.registerLazySingleton<IOrderService>(() => OrderServiceImpl());
  orderLocator.registerLazySingleton<IOrderDatasource>(
      () => OrderFirebaseDatasourceImpl(firebase: orderLocator()));
  orderLocator.registerLazySingleton<IOrderRepository>(
      () => OrderRepositoryImpl(orderLocator()));
  orderLocator.registerLazySingleton<IOrderUsecase>(
      () => OrderUsecaseImpl(orderLocator()));
  orderLocator.registerSingleton<OrderController>(OrderController(
    orderLocator(),
    orderLocator(),
    orderLocator(),
    orderLocator(),
    orderLocator(),
    orderLocator(),
  ));
  orderLocator.registerFactory<OrderRegistrationController>(() =>
      OrderRegistrationController(
          orderLocator(), orderLocator(), orderLocator(), orderLocator()));
  orderLocator.registerFactory<OrderReportController>(
      () => OrderReportController(orderLocator(), orderLocator(), orderLocator(),));
}

unregisterOrderLocator() async {
  orderLocator.unregister(instance: IOrderService);
  orderLocator.unregister(instance: IOrderDatasource);
  orderLocator.unregister(instance: IOrderRepository);
  orderLocator.unregister(instance: IOrderUsecase);
  orderLocator.unregister(instance: OrderController);
  orderLocator.unregister(instance: OrderRegistrationController);
  orderLocator.unregister(instance: OrderReportController);
}
