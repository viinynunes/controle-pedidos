import 'package:dartz/dartz.dart';

import '../../../../domain/entities/user.dart';
import '../../domain/repositories/i_login_repository.dart';
import '../../errors/login_error.dart';
import '../../presenter/models/user_credential.dart';
import '../datasources/i_login_datasource.dart';

class LoginRepositoryImpl implements ILoginRepository {
  final ILoginDatasource _datasource;

  LoginRepositoryImpl(this._datasource);

  @override
  Future<Either<LoginError, User>> getLoggedUser() async {
    try {
      return Right(await _datasource.getLoggedUser());
    } catch (e) {
      return Left(LoginError(e.toString()));
    }
  }

  @override
  Future<Either<LoginError, User>> login(UserCredential user) async {
    try {
      final result = await _datasource.login(user);

      return Right(result);
    } on LoginError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LoginError(e.toString()));
    }
  }

  @override
  Future<Either<LoginError, void>> logout() async {
    try {
      return Right(_datasource.logout());
    } catch (e) {
      return Left(LoginError(e.toString()));
    }
  }

  @override
  Future<Either<LoginError, void>> sendPasswordResetEmail(String email) async {
    try {
      return Right(await _datasource.sendPasswordResetEmail(email));
    } on LoginError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LoginError(e.toString()));
    }
  }
}
