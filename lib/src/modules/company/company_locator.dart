import 'package:controle_pedidos/src/modules/company/external/company_shared_preferences_datasource_impl.dart';
import 'package:controle_pedidos/src/modules/company/infra/datasources/i_company_datasource.dart';
import 'package:controle_pedidos/src/modules/company/presenter/stores/company_details_controller.dart';
import 'package:get_it/get_it.dart';

final companyLocator = GetIt.instance;

void setUpCompanyLocator() {
  companyLocator.registerLazySingleton<ICompanyDatasource>(
      () => CompanySharedPreferencesDatasourceImpl());
  companyLocator
      .registerFactory(() => CompanyDetailsController(companyLocator()));
}
