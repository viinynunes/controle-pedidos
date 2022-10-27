import 'package:controle_pedidos/src/modules/client/domain/entities/client.dart';
import 'package:controle_pedidos/src/modules/client/domain/repositories/i_client_repository.dart';
import 'package:controle_pedidos/src/modules/client/errors/client_errors.dart';
import 'package:controle_pedidos/src/modules/client/infra/datasources/i_client_datasource.dart';
import 'package:dartz/dartz.dart';

import '../models/client_model.dart';

class ClientRepositoryImpl implements IClientRepository {
  final IClientDatasource _datasource;

  ClientRepositoryImpl(this._datasource);

  @override
  Future<Either<ClientError, bool>> createClient(Client client) async {
    try {
      final result =
          await _datasource.createClient(ClientModel.fromClient(client));

      return Right(result);
    } catch (e) {
      return Left(ClientError(e.toString()));
    }
  }

  @override
  Future<Either<ClientError, bool>> updateClient(Client client) async {
    try {
      final result =
          await _datasource.updateClient(ClientModel.fromClient(client));

      return Right(result);
    } catch (e) {
      return Left(ClientError(e.toString()));
    }
  }

  @override
  Future<Either<ClientError, bool>> disableClient(Client client) async {
    try {
      final result =
          await _datasource.updateClient(ClientModel.fromClient(client));

      return Right(result);
    } catch (e) {
      return Left(ClientError(e.toString()));
    }
  }

  @override
  Future<Either<ClientError, Client>> getClientByID(String id) async {
    try {
      final result = await _datasource.getClientByID(id);

      return Right(result);
    } catch (e) {
      return Left(ClientError(e.toString()));
    }
  }

  @override
  Future<Either<ClientError, List<Client>>> getClientList() async {
    try {
      final result = await _datasource.getClientList();

      return Right(result);
    } catch (e) {
      return Left(ClientError(e.toString()));
    }
  }
}
