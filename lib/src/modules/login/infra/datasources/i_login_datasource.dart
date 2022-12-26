import '../../../../domain/entities/user.dart';
import '../../presenter/models/user_credential.dart';

abstract class ILoginDatasource {
  Future<User> login(UserCredential user);

  Future<bool> logout();

  Future<UserCredential> getLoggedUser();
}
