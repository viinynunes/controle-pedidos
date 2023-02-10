import 'dart:developer';

import 'package:controle_pedidos/src/core/exceptions/external_exception.dart';
import 'package:controle_pedidos/src/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/domain/models/establish_model.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/repositories/i_establishment_repository.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_info_exception.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/datasources/i_establishment_datasource.dart';
import 'package:dartz/dartz.dart';

class EstablishmentRepositoryImpl implements IEstablishmentRepository {
  final IEstablishmentDatasource _datasource;

  EstablishmentRepositoryImpl(this._datasource);

  @override
  Future<Either<EstablishmentInfoException, Establishment>> createEstablishment(
      Establishment establishment) async {
    try {
      final result = await _datasource.createEstablishment(
          EstablishmentModel.fromEstablishment(establishment: establishment));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(EstablishmentInfoException('Erro interno'));
    } on EstablishmentInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<EstablishmentInfoException, Establishment>> updateEstablishment(
      Establishment establishment) async {
    try {
      final result = await _datasource.updateEstablishment(
          EstablishmentModel.fromEstablishment(establishment: establishment));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(EstablishmentInfoException('Erro interno'));
    } on EstablishmentInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<EstablishmentInfoException, Establishment>> getEstablishmentById(
      String id) async {
    try {
      final result = await _datasource.getEstablishmentById(id);

      return Right(result);
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(EstablishmentInfoException('Erro interno'));
    } on EstablishmentInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<EstablishmentInfoException, List<Establishment>>>
      getEstablishmentList() async {
    try {
      final result = await _datasource.getEstablishmentList();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(EstablishmentInfoException('Erro interno'));
    } on EstablishmentInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<EstablishmentInfoException, List<Establishment>>>
      getEstablishmentListByEnabled() async {
    try {
      final result = await _datasource.getEstablishmentListByEnabled();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Error', error: e.error, stackTrace: e.stackTrace);
      return Left(EstablishmentInfoException('Erro interno'));
    } on EstablishmentInfoException catch (e) {
      return Left(e);
    }
  }
}
