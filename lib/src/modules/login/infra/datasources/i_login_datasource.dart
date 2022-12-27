import '../../../../domain/models/user_model.dart';
import '../../presenter/models/user_credential.dart';

abstract class ILoginDatasource {
  Future<UserModel> login(UserCredential user);

  Future<void> logout();

  Future<UserModel> getLoggedUser();
}
