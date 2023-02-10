import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/errors/provider_info_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IProviderUsecase {
  Future<Either<ProviderInfoException, Provider>> createProvider(Provider provider);

  Future<Either<ProviderInfoException, Provider>> updateProvider(Provider provider);

  Future<Either<ProviderInfoException, Provider>> getProviderById(String id);

  Future<Either<ProviderInfoException, List<Provider>>> getProviderListByEnabled();

  Future<Either<ProviderInfoException, List<Provider>>> getProviderList();
}
