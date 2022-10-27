import 'package:dartz/dartz.dart';

import '../../errors/client_errors.dart';
import '../entities/client.dart';

abstract class IClientUsecase {
  Future<Either<ClientError, bool>> createClient(Client client);

  Future<Either<ClientError, bool>> updateClient(Client client);

  Future<Either<ClientError, bool>> disableClient(Client client);

  Future<Either<ClientError, Client>> getClientByID(String id);

  Future<Either<ClientError, List<Client>>> getClientList();
}
