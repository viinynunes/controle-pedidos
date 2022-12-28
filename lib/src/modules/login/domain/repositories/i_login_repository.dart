import 'package:dartz/dartz.dart';

import '../../../../domain/entities/user.dart';
import '../../errors/login_error.dart';
import '../../presenter/models/user_credential.dart';

abstract class ILoginRepository {
  Future<Either<LoginError, User>> login(UserCredential user);

  Future<Either<LoginError, void>> logout();

  Future<Either<LoginError, User>> getLoggedUser();

  Future<Either<LoginError, void>> sendPasswordResetEmail(String email);

  Future<Either<LoginError, User>> createUserWithEmailAndPassword(
      User user, String password);
}
