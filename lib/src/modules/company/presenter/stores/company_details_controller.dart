import 'package:controle_pedidos/src/modules/login/domain/usecases/i_login_usecase.dart';
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
  logout() async {
    await loginUsecase.logout();
  }
}
