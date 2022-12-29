import 'package:controle_pedidos/src/domain/models/company_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infra/datasources/i_company_datasource.dart';

class CompanySharedPreferencesDatasourceImpl implements ICompanyDatasource {
  @override
  Future<CompanyModel> getLoggedCompany() async {
    final prefs = await SharedPreferences.getInstance();

    return CompanyModel.fromJson(prefs.get('company') as String);
  }

  @override
  Future<void> saveLoggedCompany(CompanyModel company) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('company', company.toJson());
  }
}
