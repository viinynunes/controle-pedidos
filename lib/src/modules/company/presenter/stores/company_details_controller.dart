import 'package:controle_pedidos/src/core/helpers/custom_page_route.dart';
import 'package:controle_pedidos/src/modules/login/domain/usecases/i_login_usecase.dart';
import 'package:controle_pedidos/src/modules/login/presenter/pages/android/android_login_page.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/user.dart';

part 'company_details_controller.g.dart';

class CompanyDetailsController = _CompanyDetailsControllerBase
    with _$CompanyDetailsController;

abstract class _CompanyDetailsControllerBase with Store {
  final ILoginUsecase loginUsecase;

  _CompanyDetailsControllerBase(this.loginUsecase);

  @observable
  bool loading = false;
  @observable
  User? user;

  @action
  getLoggedUser() async {
    final result = await loginUsecase.getLoggedUser();

    result.fold((l) => null, (r) => user = r);
  }

  @action
  logout(BuildContext context) async {
    await loginUsecase.logout();

    Navigator.of(context)
        .pushReplacement(CustomPageRoute(child: const AndroidLoginPage()));
  }
}
