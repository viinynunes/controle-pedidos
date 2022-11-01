import 'package:dartz/dartz.dart';

import '../../errors/client_errors.dart';
import '../entities/client.dart';

abstract class IClientRepository {
  Future<Either<ClientError, Client>> createClient(Client client);

  Future<Either<ClientError, Client>> updateClient(Client client);

  Future<Either<ClientError, bool>> disableClient(Client client);

  Future<Either<ClientError, Client>> getClientByID(String id);

  Future<Either<ClientError, List<Client>>> getClientListByEnabled();

  Future<Either<ClientError, List<Client>>> getClientList();
}
