import 'package:controle_pedidos/src/modules/provider/domain/repositories/i_provider_repository.dart';
import 'package:controle_pedidos/src/modules/provider/domain/usecases/I_provider_usecase.dart';
import 'package:controle_pedidos/src/modules/provider/domain/usecases/impl/provider_usecase_impl.dart';
import 'package:controle_pedidos/src/modules/provider/external/provider_firebase_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/provider/infra/datasources/i_provider_datasource.dart';
import 'package:controle_pedidos/src/modules/provider/infra/repositories/provider_repository_impl.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/stores/provider_controller.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/stores/provider_registration_controller.dart';
import 'package:get_it/get_it.dart';

import 'services/i_provider_service.dart';
import 'services/impl/provider_service_impl.dart';

final providerLocator = GetIt.instance;

void setUpProviderLocator() {
  providerLocator.registerLazySingleton<IProviderDatasource>(
      () => ProviderFirebaseDatasourceImpl());
  providerLocator.registerLazySingleton<IProviderRepository>(
      () => ProviderRepositoryImpl(providerLocator()));
  providerLocator.registerLazySingleton<IProviderUsecase>(
      () => ProviderUsecaseImpl(providerLocator()));
  providerLocator
      .registerLazySingleton<IProviderService>(() => ProviderServiceImpl());
  providerLocator.registerLazySingleton<ProviderController>(
      () => ProviderController(providerLocator()));
  providerLocator.registerFactory<ProviderRegistrationController>(() =>
      ProviderRegistrationController(
          providerLocator(), providerLocator(), providerLocator()));
}
