import 'package:controle_pedidos/src/modules/provider/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/errors/provider_error.dart';
import 'package:dartz/dartz.dart';

abstract class IProviderUsecase {
  Future<Either<ProviderError, Provider>> createProvider(Provider provider);

  Future<Either<ProviderError, Provider>> updateProvider(Provider provider);

  Future<Either<ProviderError, List<Provider>>> getProviderListByEnabled();

  Future<Either<ProviderError, List<Provider>>> getProviderList();
}
