import 'package:controle_pedidos/src/modules/company/infra/datasources/i_company_datasource.dart';

import '../../../../domain/entities/enums/company_subscription.dart';
import '../ad_service.dart';

class AdServiceImpl implements AdService {
  final ICompanyDatasource _companyDatasource;

  AdServiceImpl(this._companyDatasource);

  @override
  bool loadAd() {
    return _companyDatasource.getLoggedCompany().subscription ==
        CompanySubscription.free;
  }
}
