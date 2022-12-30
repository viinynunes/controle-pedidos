import '../../../../domain/models/company_model.dart';

abstract class ICompanyDatasource {
  CompanyModel getLoggedCompany();

  void saveLoggedCompany(CompanyModel company);

  void logout();
}
