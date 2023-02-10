import 'dart:developer';

import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/modules/provider/domain/repositories/i_provider_repository.dart';
import 'package:controle_pedidos/src/modules/provider/errors/provider_info_exception.dart';
import 'package:controle_pedidos/src/modules/provider/infra/datasources/i_provider_datasource.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/external_exception.dart';

class ProviderRepositoryImpl implements IProviderRepository {
  final IProviderDatasource _datasource;

  ProviderRepositoryImpl(this._datasource);

  @override
  Future<Either<ProviderInfoException, Provider>> createProvider(
      Provider provider) async {
    try {
      final result = await _datasource
          .createProvider(ProviderModel.fromProvider(provider));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProviderInfoException('Erro interno no servidor'));
    } on ProviderInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProviderInfoException, Provider>> updateProvider(
      Provider provider) async {
    try {
      final result = await _datasource
          .updateProvider(ProviderModel.fromProvider(provider));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProviderInfoException('Erro interno no servidor'));
    } on ProviderInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProviderInfoException, Provider>> getProviderById(String id) async {
    try {
      final result = await _datasource.getProviderById(id);

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProviderInfoException('Erro interno no servidor'));
    } on ProviderInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProviderInfoException, List<Provider>>> getProviderList() async {
    try {
      final result = await _datasource.getProviderList();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProviderInfoException('Erro interno no servidor'));
    } on ProviderInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ProviderInfoException, List<Provider>>>
      getProviderListByEnabled() async {
    try {
      final result = await _datasource.getProviderListByEnabled();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ProviderInfoException('Erro interno no servidor'));
    } on ProviderInfoException catch (e) {
      return Left(e);
    }
  }
}
