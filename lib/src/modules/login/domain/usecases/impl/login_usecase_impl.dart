import 'package:dartz/dartz.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../../domain/entities/user.dart';
import '../../../errors/login_error.dart';
import '../../../presenter/models/user_credential.dart';
import '../../repositories/i_login_repository.dart';
import '../i_login_usecase.dart';

class LoginUsecaseImpl implements ILoginUsecase {
  final ILoginRepository _repository;

  LoginUsecaseImpl(this._repository);

  @override
  Future<Either<LoginError, User>> getLoggedUser() {
    return _repository.getLoggedUser();
  }

  @override
  Future<Either<LoginError, User>> login(UserCredential user) async {
    if (!isEmail(user.email)) {
      return Left(LoginError('Invalid Email'));
    }

    if (user.password.isEmpty || user.password.length < 6) {
      return Left(LoginError('Invalid Password'));
    }

    return _repository.login(user);
  }

  @override
  Future<Either<LoginError, void>> logout() {
    return _repository.logout();
  }

  @override
  Future<Either<LoginError, void>> sendPasswordResetEmail(String email) async {
    if (!isEmail(email)) {
      return Left(LoginError('Invalid Email'));
    }

    return _repository.sendPasswordResetEmail(email);
  }

  @override
  Future<Either<LoginError, User>> createUserWithEmailAndPassword(
      User user, String password) async {
    if (!isEmail(user.email)) {
      return Left(LoginError('Invalid Email'));
    }

    if (password.isEmpty || password.length < 6) {
      return Left(LoginError('Invalid Password'));
    }

    if (user.company.id.isEmpty) {
      return Left(LoginError('Invalid Company ID'));
    }

    if (user.company.name.isEmpty) {
      return Left(LoginError('Invalid Company Name'));
    }

    return _repository.createUserWithEmailAndPassword(user, password);
  }
}
