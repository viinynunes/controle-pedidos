import 'package:dartz/dartz.dart';

import '../../../../domain/entities/user.dart';
import '../../errors/login_info_exception.dart';
import '../../presenter/models/user_credential.dart';

abstract class ILoginUsecase {
  Future<Either<LoginInfoException, User>> login(UserCredential user);

  Future<Either<LoginInfoException, void>> logout();

  Future<Either<LoginInfoException, User>> getLoggedUser();

  Future<Either<LoginInfoException, void>> sendPasswordResetEmail(String email);

  Future<Either<LoginInfoException, User>> createUserWithEmailAndPassword(
      User user, String password);
}
