import 'package:dartz/dartz.dart';

import '../../errors/client_info_exception.dart';
import '../../../../domain/entities/client.dart';

abstract class IClientUsecase {
  Future<Either<ClientInfoException, Client>> createClient(Client client);

  Future<Either<ClientInfoException, Client>> updateClient(Client client);

  Future<Either<ClientInfoException, bool>> disableClient(Client client);

  Future<Either<ClientInfoException, Client>> getClientByID(String id);

  Future<Either<ClientInfoException, List<Client>>> getClientEnabled();

  Future<Either<ClientInfoException, List<Client>>> getClientList();
}
