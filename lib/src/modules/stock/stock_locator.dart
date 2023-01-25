import 'package:controle_pedidos/src/modules/stock/domain/repositories/i_new_stock_repository.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/change_stock_date_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/decrease_stock_total_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/delete_stock_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/get_stock_lists_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/change_stock_date_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/decrease_stock_total_ordered_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/delete_stock_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/get_stock_lists_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/increase_stock_total_ordered_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/increase_stock_total_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/impl/update_stock_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/increase_stock_total_ordered_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/update_stock_usecase.dart';
import 'package:controle_pedidos/src/modules/stock/external/new_stock_firebase_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/stock/infra/datasources/i_new_stock_datasource.dart';
import 'package:controle_pedidos/src/modules/stock/presenter/store/divide_stock_dialog_controller.dart';
import 'package:controle_pedidos/src/modules/stock/presenter/store/stock_controller.dart';
import 'package:controle_pedidos/src/modules/stock/services/i_stock_service.dart';
import 'package:get_it/get_it.dart';

import 'domain/usecases/decrease_stock_total_ordered_usecase.dart';
import 'domain/usecases/impl/decrease_stock_total_usecase_impl.dart';
import 'domain/usecases/increase_stock_total_usecase.dart';
import 'infra/repositories/new_stock_repository_impl.dart';
import 'presenter/store/report_stock_by_establishment_controller.dart';
import 'presenter/store/report_stock_by_provider_controller.dart';
import 'presenter/store/show_orders_by_stock_dialog_controller.dart';
import 'presenter/store/stock_tile_controller.dart';
import 'services/impl/stock_service_impl.dart';

final stockLocator = GetIt.instance;

void setUpStockLocator() {
  stockLocator.registerLazySingleton<IStockService>(() => StockServiceImpl());
  stockLocator.registerLazySingleton<INewStockDatasource>(
      () => NewStockFirebaseDatasourceImpl(firebase: stockLocator()));
  stockLocator.registerLazySingleton<INewStockRepository>(
      () => NewStockRepositoryImpl(stockLocator()));
  stockLocator.registerLazySingleton<ChangeStockDateUsecase>(
      () => ChangeStockDateUsecaseImpl(stockLocator()));
  stockLocator.registerLazySingleton<DecreaseStockTotalUsecase>(
      () => DecreaseStockTotalUsecaseImpl(stockLocator()));
  stockLocator.registerLazySingleton<DecreaseStockTotalOrderedUsecase>(
      () => DecreaseStockTotalOrderedUsecaseImpl(stockLocator()));
  stockLocator.registerLazySingleton<DeleteStockUsecase>(
      () => DeleteStockUsecaseImpl(stockLocator()));
  stockLocator.registerLazySingleton<GetStockListsUsecase>(
      () => GetStockListsUsecaseImpl(stockLocator()));
  stockLocator.registerLazySingleton<IncreaseStockTotalOrderedUsecase>(
      () => IncreaseStockTotalOrderedUsecaseImpl(stockLocator()));
  stockLocator.registerLazySingleton<IncreaseStockTotalUsecase>(
      () => IncreaseStockTotalUsecaseImpl(stockLocator()));
  stockLocator.registerLazySingleton<UpdateStockUsecase>(
      () => UpdateStockUsecaseImpl(stockLocator()));
  stockLocator.registerSingleton<StockController>(StockController(
      stockLocator(),
      stockLocator(),
      stockLocator(),
      stockLocator(),
      stockLocator(),
      stockLocator(),
      stockLocator()));
  stockLocator.registerFactory<StockTileController>(
      () => StockTileController(stockLocator()));
  stockLocator.registerFactory<DivideStockDialogController>(
      () => DivideStockDialogController(stockLocator()));
  stockLocator.registerFactory<ShowOrdersByStockDialogController>(
      () => ShowOrdersByStockDialogController(stockLocator()));
  stockLocator.registerFactory<ReportStockByProviderController>(
      () => ReportStockByProviderController(stockLocator(), stockLocator()));
  stockLocator.registerFactory<ReportStockByEstablishmentController>(() =>
      ReportStockByEstablishmentController(stockLocator(), stockLocator()));
}
