import 'package:dartz/dartz.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../../domain/entities/user.dart';
import '../../../errors/login_info_exception.dart';
import '../../../presenter/models/user_credential.dart';
import '../../repositories/i_login_repository.dart';
import '../i_login_usecase.dart';

class LoginUsecaseImpl implements ILoginUsecase {
  final ILoginRepository _repository;

  LoginUsecaseImpl(this._repository);

  @override
  Future<Either<LoginInfoException, User>> getLoggedUser() {
    return _repository.getLoggedUser();
  }

  @override
  Future<Either<LoginInfoException, User>> login(UserCredential user) async {
    if (!isEmail(user.email)) {
      return Left(LoginInfoException('Email inválido'));
    }

    if (user.password.isEmpty || user.password.length < 6) {
      return Left(LoginInfoException('Senha inválida'));
    }

    return _repository.login(user);
  }

  @override
  Future<Either<LoginInfoException, void>> logout() {
    return _repository.logout();
  }

  @override
  Future<Either<LoginInfoException, void>> sendPasswordResetEmail(String email) async {
    if (!isEmail(email)) {
      return Left(LoginInfoException('Email inválido'));
    }

    return _repository.sendPasswordResetEmail(email);
  }

  @override
  Future<Either<LoginInfoException, User>> createUserWithEmailAndPassword(
      User user, String password) async {
    if (!isEmail(user.email)) {
      return Left(LoginInfoException('Email inválido'));
    }

    if (password.isEmpty || password.length < 6) {
      return Left(LoginInfoException('Senha inválida'));
    }

    if (user.company.id.isEmpty) {
      return Left(LoginInfoException('ID inválido'));
    }

    if (user.company.name.isEmpty) {
      return Left(LoginInfoException('Nome da empresa inválida'));
    }

    return _repository.createUserWithEmailAndPassword(user, password);
  }
}
