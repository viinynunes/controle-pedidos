import 'dart:async';
import 'dart:developer';

import 'package:controle_pedidos/src/modules/company/infra/datasources/i_company_datasource.dart';

import '../../../../domain/entities/enums/company_subscription.dart';
import '../ad_service.dart';

class AdServiceImpl implements AdService {
  final ICompanyDatasource _companyDatasource;

  AdServiceImpl(this._companyDatasource);

  @override
  Stream<bool> loadAd() async* {
    bool showAd = false;

    if (_companyDatasource.getLoggedCompany().subscription ==
        CompanySubscription.free) {
      Timer.periodic(const Duration(seconds: 15), (timer) {
        showAd = true;
        log('Ready to show ads');
      });
    }

    yield showAd;
  }

  @override
  bool showBannerAd() {
    return _companyDatasource.getLoggedCompany().subscription ==
        CompanySubscription.free;
  }
}
