import 'package:controle_pedidos/src/modules/product/domain/repositories/i_product_repository.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/i_product_usecase.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/impl/product_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/product/infra/datasources/i_product_datasource.dart';
import 'package:controle_pedidos/src/modules/product/infra/repositories/product_repository_impl.dart';
import 'package:controle_pedidos/src/modules/product/presenter/stores/product_controller.dart';
import 'package:get_it/get_it.dart';

import 'external/product_firebase_datasource_impl.dart';
import 'presenter/stores/product_registration_controller.dart';
import 'presenter/stores/product_stock_default_controller.dart';

final productLocator = GetIt.instance;

void setUpProductLocator() {
  productLocator.registerLazySingleton<IProductDatasource>(
      () => ProductFirebaseDatasourceImpl(firebase: productLocator()));
  productLocator.registerLazySingleton<IProductRepository>(
      () => ProductRepositoryImpl(productLocator()));
  productLocator.registerLazySingleton<IProductUsecase>(
      () => ProductUsecaseImpl(productLocator()));
  productLocator.registerLazySingleton<ProductController>(
      () => ProductController(productLocator(), productLocator()));
  productLocator.registerFactory<ProductRegistrationController>(() =>
      ProductRegistrationController(
          productLocator(), productLocator(), productLocator(), productLocator()));
  productLocator.registerFactory<ProductStockDefaultController>(
      () => ProductStockDefaultController(productLocator(), productLocator()));
}


void unregisterProductLocator(){
  productLocator.unregister(instance: IProductDatasource);
  productLocator.unregister(instance: IProductRepository);
  productLocator.unregister(instance: IProductUsecase);
  productLocator.unregister(instance: ProductController);
  productLocator.unregister(instance: ProductRegistrationController);
  productLocator.unregister(instance: ProductStockDefaultController);
}
