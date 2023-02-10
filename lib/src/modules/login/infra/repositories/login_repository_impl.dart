import 'dart:developer';

import 'package:controle_pedidos/src/core/exceptions/external_exception.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/entities/user.dart';
import '../../../../domain/models/user_model.dart';
import '../../domain/repositories/i_login_repository.dart';
import '../../errors/login_info_exception.dart';
import '../../presenter/models/user_credential.dart';
import '../datasources/i_login_datasource.dart';

class LoginRepositoryImpl implements ILoginRepository {
  final ILoginDatasource _datasource;

  LoginRepositoryImpl(this._datasource);

  @override
  Future<Either<LoginInfoException, User>> getLoggedUser() async {
    try {
      return Right(await _datasource.getLoggedUser());
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(LoginInfoException('Erro interno'));
    } on LoginInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<LoginInfoException, User>> login(UserCredential user) async {
    try {
      final result = await _datasource.login(user);

      return Right(result);
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(LoginInfoException('Erro interno'));
    } on LoginInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<LoginInfoException, void>> logout() async {
    try {
      return Right(_datasource.logout());
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(LoginInfoException('Erro interno'));
    } on LoginInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<LoginInfoException, void>> sendPasswordResetEmail(String email) async {
    try {
      return Right(await _datasource.sendPasswordResetEmail(email));
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(LoginInfoException('Erro interno'));
    } on LoginInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<LoginInfoException, User>> createUserWithEmailAndPassword(
      User user, String password) async {
    try {
      return Right(await _datasource.createUserWithEmailAndPassword(
          UserModel.fromUser(user: user), password));
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(LoginInfoException('Erro interno'));
    } on LoginInfoException catch (e) {
      return Left(e);
    }
  }
}
