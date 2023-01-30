import 'package:controle_pedidos/src/modules/client/presenter/stores/client_registration_controller.dart';
import 'package:get_it/get_it.dart';

import 'domain/repositories/i_client_repository.dart';
import 'domain/usecases/i_client_usecase.dart';
import 'domain/usecases/impl/client_usecase_impl.dart';
import 'external/client_firebase_datasource_impl.dart';
import 'infra/datasources/i_client_datasource.dart';
import 'infra/repositories/client_repository_impl.dart';
import 'presenter/stores/client_controller.dart';

final clientLocator = GetIt.instance;

void setUpClientLocator() {
  clientLocator.registerSingleton<IClientDatasource>(
      ClientFirebaseDatasourceImpl(firebase: clientLocator()));
  clientLocator.registerSingleton<IClientRepository>(
      ClientRepositoryImpl(clientLocator()));
  clientLocator
      .registerSingleton<IClientUsecase>(ClientUsecaseImpl(clientLocator()));
  clientLocator
      .registerSingleton<ClientController>(ClientController(clientLocator()));
  clientLocator.registerFactory<ClientRegistrationController>(
      () => ClientRegistrationController(clientLocator()));
}

void unregisterClientLocator() {
  clientLocator.unregister(instance: IClientDatasource);
  clientLocator.unregister(instance: IClientRepository);
  clientLocator.unregister(instance: IClientUsecase);
  clientLocator.unregister(instance: ClientController);
  clientLocator.unregister(instance: ClientRegistrationController);
}
