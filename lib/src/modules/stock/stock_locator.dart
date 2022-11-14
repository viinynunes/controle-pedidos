import 'package:controle_pedidos/src/modules/stock/presenter/store/stock_controller.dart';
import 'package:controle_pedidos/src/modules/stock/services/i_stock_service.dart';
import 'package:get_it/get_it.dart';

import 'domain/repositories/i_stock_repository.dart';
import 'domain/usecases/i_stock_usecase.dart';
import 'domain/usecases/impl/stock_usecase_impl.dart';
import 'external/stock_firebase_datasource_impl.dart';
import 'infra/datasources/i_stock_datasource.dart';
import 'infra/repositories/stock_repository_impl.dart';
import 'presenter/store/stock_tile_controller.dart';
import 'services/impl/stock_service_impl.dart';

final stockLocator = GetIt.instance;

void setUpStockLocator() {
  stockLocator.registerLazySingleton<IStockService>(() => StockServiceImpl());
  stockLocator.registerLazySingleton<IStockDatasource>(
      () => StockFirebaseDatasourceImpl());
  stockLocator.registerLazySingleton<IStockRepository>(
      () => StockRepositoryImpl(stockLocator()));
  stockLocator.registerLazySingleton<IStockUsecase>(
      () => StockUsecaseImpl(stockLocator()));
  stockLocator.registerSingleton<StockController>(
      StockController(stockLocator(), stockLocator()));
  stockLocator.registerFactory<StockTileController>(
      () => StockTileController(stockLocator()));
}
