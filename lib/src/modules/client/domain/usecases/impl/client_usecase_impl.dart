import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/modules/client/domain/repositories/i_client_repository.dart';
import 'package:controle_pedidos/src/modules/client/domain/usecases/i_client_usecase.dart';
import 'package:controle_pedidos/src/modules/client/errors/client_errors.dart';
import 'package:dartz/dartz.dart';
import 'package:string_validator/string_validator.dart';

class ClientUsecaseImpl implements IClientUsecase {
  final IClientRepository _repository;

  ClientUsecaseImpl(this._repository);

  @override
  Future<Either<ClientError, Client>> createClient(Client client) async {
    if (client.name.length < 2) {
      return Left(ClientError('Invalid client name'));
    }

    if (client.email.isNotEmpty && !isEmail(client.email)) {
      return Left(ClientError('Invalid email'));
    }

    if (client.phone.isNotEmpty && client.phone.length != 11) {
      return Left(ClientError('Invalid phone'));
    }

    return _repository.createClient(client);
  }

  @override
  Future<Either<ClientError, Client>> updateClient(Client client) async {
    if (client.id.isEmpty) {
      return Left(ClientError('Invalid ID'));
    }

    if (client.name.length < 2) {
      return Left(ClientError('Invalid client name'));
    }

    if (client.email.isNotEmpty && !isEmail(client.email)) {
      return Left(ClientError('Invalid email'));
    }

    if (client.phone.isNotEmpty && client.phone.length != 11) {
      return Left(ClientError('Invalid phone'));
    }

    return _repository.updateClient(client);
  }

  @override
  Future<Either<ClientError, bool>> disableClient(Client client) async {
    if (client.id.isEmpty) {
      return Left(ClientError('Invalid ID'));
    }

    return _repository.disableClient(client);
  }

  @override
  Future<Either<ClientError, Client>> getClientByID(String id) async {
    if (id.isEmpty) {
      return Left(ClientError('Invalid ID'));
    }

    return getClientByID(id);
  }

  @override
  Future<Either<ClientError, List<Client>>> getClientList() async {
    return _repository.getClientList();
  }

  @override
  Future<Either<ClientError, List<Client>>> getClientEnabled() {
    return _repository.getClientListByEnabled();
  }
}
