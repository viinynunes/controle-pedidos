import 'package:get_it/get_it.dart';

import 'domain/repositories/i_login_repository.dart';
import 'domain/usecases/i_login_usecase.dart';
import 'domain/usecases/impl/login_usecase_impl.dart';
import 'external/login_firebase_datasource_impl.dart';
import 'infra/datasources/i_login_datasource.dart';
import 'infra/repositories/login_repository_impl.dart';
import 'presenter/stores/login_controller.dart';
import 'presenter/stores/signup_controller.dart';

final loginLocator = GetIt.instance;

void setUpLoginLocator() {
  loginLocator.registerLazySingleton<ILoginDatasource>(
      () => LoginFirebaseDatasourceImpl(loginLocator()));
  loginLocator.registerLazySingleton<ILoginRepository>(
      () => LoginRepositoryImpl(loginLocator()));
  loginLocator.registerLazySingleton<ILoginUsecase>(
      () => LoginUsecaseImpl(loginLocator()));
  loginLocator.registerFactory(() => LoginController(loginLocator()));
  loginLocator.registerFactory(() => SignupController(loginLocator()));
}
