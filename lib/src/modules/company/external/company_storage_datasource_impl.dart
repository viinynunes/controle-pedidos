import 'package:controle_pedidos/src/domain/models/company_model.dart';
import 'package:get_storage/get_storage.dart';

import '../infra/datasources/i_company_datasource.dart';

class CompanyStorageDatasourceImpl implements ICompanyDatasource {
  final box = GetStorage();

  @override
  CompanyModel getLoggedCompany() {
    return CompanyModel.fromJson(box.read('company'));
  }

  @override
  void saveLoggedCompany(CompanyModel company) {
    box.write('company', company.toJson());
    box.write('companyID', company.id);
  }

  @override
  void logout() {
    box.remove('company');
    box.remove('companyID');
  }
}
