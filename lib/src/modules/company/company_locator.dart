import 'package:controle_pedidos/src/modules/company/presenter/stores/company_details_controller.dart';
import 'package:get_it/get_it.dart';

final companyLocator = GetIt.instance;

void setUpCompanyLocator() {
  companyLocator
      .registerFactory(() => CompanyDetailsController(companyLocator()));
}
