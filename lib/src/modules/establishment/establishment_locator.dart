import 'package:controle_pedidos/src/modules/establishment/domain/repositories/i_establishment_repository.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/services/i_establishment_service.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/services/impl/establishment_service_impl.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/usecases/i_establishment_usecase.dart';
import 'package:controle_pedidos/src/modules/establishment/external/establishment_firebase_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/datasources/i_establishment_datasource.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/repositories/establishment_repository_impl.dart';
import 'package:controle_pedidos/src/modules/establishment/presenter/stores/establishment_controller.dart';
import 'package:get_it/get_it.dart';

import 'domain/usecases/impl/establishment_usecase_impl.dart';
import 'presenter/stores/establishment_registration_controller.dart';

final estabLocator = GetIt.instance;

void setUpEstablishmentLocator() {
  estabLocator.registerLazySingleton<IEstablishmentDatasource>(
      () => EstablishmentFirebaseDatasourceImpl(firebase: estabLocator()));
  estabLocator.registerLazySingleton<IEstablishmentRepository>(
      () => EstablishmentRepositoryImpl(estabLocator()));
  estabLocator.registerLazySingleton<IEstablishmentUsecase>(
      () => EstablishmentUsecaseImpl(estabLocator()));
  estabLocator.registerLazySingleton<IEstablishmentService>(
      () => EstablishmentServiceImpl());
  estabLocator.registerLazySingleton<EstablishmentController>(
      () => EstablishmentController(estabLocator()));
  estabLocator.registerFactory<EstablishmentRegistrationController>(
      () => EstablishmentRegistrationController(estabLocator()));
}

void unregisterEstablishmentLocator(){
  estabLocator.unregister(instance: IEstablishmentDatasource);
  estabLocator.unregister(instance: IEstablishmentRepository);
  estabLocator.unregister(instance: IEstablishmentUsecase);
  estabLocator.unregister(instance: IEstablishmentService);
  estabLocator.unregister(instance: EstablishmentController);
  estabLocator.unregister(instance: EstablishmentRegistrationController);
}