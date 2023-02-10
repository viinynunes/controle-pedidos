import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/domain/repositories/i_provider_repository.dart';
import 'package:controle_pedidos/src/modules/provider/domain/usecases/i_provider_usecase.dart';
import 'package:controle_pedidos/src/modules/provider/errors/provider_info_exception.dart';
import 'package:dartz/dartz.dart';

class ProviderUsecaseImpl implements IProviderUsecase {
  final IProviderRepository _repository;

  ProviderUsecaseImpl(this._repository);

  @override
  Future<Either<ProviderInfoException, Provider>> createProvider(
      Provider provider) async {
    if (provider.name.isEmpty || provider.name.length < 2) {
      return Left(ProviderInfoException('Nome inválido'));
    }

    if (provider.location.isEmpty) {
      return Left(ProviderInfoException('Localização inválida'));
    }

    return _repository.createProvider(provider);
  }

  @override
  Future<Either<ProviderInfoException, Provider>> updateProvider(
      Provider provider) async {
    if (provider.id.isEmpty) {
      return Left(ProviderInfoException('ID inválido'));
    }

    if (provider.name.isEmpty || provider.name.length < 2) {
      return Left(ProviderInfoException('Nome inválido'));
    }

    if (provider.location.isEmpty) {
      return Left(ProviderInfoException('Localização inválida'));
    }

    return _repository.updateProvider(provider);
  }

  @override
  Future<Either<ProviderInfoException, Provider>> getProviderById(String id) async {
    if (id.isEmpty) {
      return Left(ProviderInfoException('ID inválido'));
    }

    return _repository.getProviderById(id);
  }

  @override
  Future<Either<ProviderInfoException, List<Provider>>> getProviderList() {
    return _repository.getProviderList();
  }

  @override
  Future<Either<ProviderInfoException, List<Provider>>> getProviderListByEnabled() {
    return _repository.getProviderListByEnabled();
  }
}
