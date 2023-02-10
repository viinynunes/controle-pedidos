import 'dart:developer';

import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/modules/client/domain/repositories/i_client_repository.dart';
import 'package:controle_pedidos/src/modules/client/errors/client_info_exception.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/external_exception.dart';
import '../../../../domain/models/client_model.dart';

class ClientRepositoryImpl implements IClientRepository {
  final IClientDatasource _datasource;

  ClientRepositoryImpl(this._datasource);

  @override
  Future<Either<ClientInfoException, Client>> createClient(
      Client client) async {
    try {
      final result =
          await _datasource.createClient(ClientModel.fromClient(client));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ClientInfoException('Erro interno no servidor'));
    } on ClientInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ClientInfoException, Client>> updateClient(
      Client client) async {
    try {
      final result =
          await _datasource.updateClient(ClientModel.fromClient(client));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ClientInfoException('Erro interno no servidor'));
    } on ClientInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ClientInfoException, bool>> disableClient(Client client) async {
    try {
      client.enabled = false;

      final result =
          await _datasource.disableClient(ClientModel.fromClient(client));

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ClientInfoException('Erro interno no servidor'));
    } on ClientInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ClientInfoException, Client>> getClientByID(String id) async {
    try {
      final result = await _datasource.getClientByID(id);

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ClientInfoException('Erro interno no servidor'));
    } on ClientInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ClientInfoException, List<Client>>> getClientList() async {
    try {
      final result = await _datasource.getClientList();

      return Right(result);
    } on ExternalException catch (e) {
      log('External Exception', error: e.error, stackTrace: e.stackTrace);
      return Left(ClientInfoException('Erro interno no servidor'));
    } on ClientInfoException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ClientInfoException, List<Client>>>
      getClientListByEnabled() async {
    try {
      final result = await _datasource.getClientListByEnabled();

      return Right(result);
    } on ExternalException catch (e, s) {
      log('External Exception', error: e.error, stackTrace: s);
      return Left(ClientInfoException('Erro interno no servidor'));
    } on ClientInfoException catch (e) {
      return Left(e);
    }
  }
}
