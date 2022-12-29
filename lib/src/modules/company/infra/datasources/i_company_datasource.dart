import '../../../../domain/models/company_model.dart';

abstract class ICompanyDatasource {
  Future<CompanyModel> getLoggedCompany();

  Future<void> saveLoggedCompany(CompanyModel company);
}
