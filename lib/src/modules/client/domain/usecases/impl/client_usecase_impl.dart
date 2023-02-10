import 'package:controle_pedidos/src/domain/entities/client.dart';
import 'package:controle_pedidos/src/modules/client/domain/repositories/i_client_repository.dart';
import 'package:controle_pedidos/src/modules/client/domain/usecases/i_client_usecase.dart';
import 'package:controle_pedidos/src/modules/client/errors/client_info_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:string_validator/string_validator.dart';

class ClientUsecaseImpl implements IClientUsecase {
  final IClientRepository _repository;

  ClientUsecaseImpl(this._repository);

  @override
  Future<Either<ClientInfoException, Client>> createClient(Client client) async {
    if (client.name.length < 2) {
      return Left(ClientInfoException('Nome inválido'));
    }

    if (client.email.isNotEmpty && !isEmail(client.email)) {
      return Left(ClientInfoException('Email inválido'));
    }

    if (client.phone.isNotEmpty && client.phone.length != 11) {
      return Left(ClientInfoException('Telefone inválido'));
    }

    return _repository.createClient(client);
  }

  @override
  Future<Either<ClientInfoException, Client>> updateClient(Client client) async {
    if (client.id.isEmpty) {
      return Left(ClientInfoException('ID inválido'));
    }

    if (client.name.length < 2) {
      return Left(ClientInfoException('Nome inválido'));
    }

    if (client.email.isNotEmpty && !isEmail(client.email)) {
      return Left(ClientInfoException('Email inválido'));
    }

    if (client.phone.isNotEmpty && client.phone.length != 11) {
      return Left(ClientInfoException('Telefone inválido'));
    }

    return _repository.updateClient(client);
  }

  @override
  Future<Either<ClientInfoException, bool>> disableClient(Client client) async {
    if (client.id.isEmpty) {
      return Left(ClientInfoException('ID inválido'));
    }

    return _repository.disableClient(client);
  }

  @override
  Future<Either<ClientInfoException, Client>> getClientByID(String id) async {
    if (id.isEmpty) {
      return Left(ClientInfoException('ID inválido'));
    }

    return getClientByID(id);
  }

  @override
  Future<Either<ClientInfoException, List<Client>>> getClientList() async {
    return _repository.getClientList();
  }

  @override
  Future<Either<ClientInfoException, List<Client>>> getClientEnabled() {
    return _repository.getClientListByEnabled();
  }
}
