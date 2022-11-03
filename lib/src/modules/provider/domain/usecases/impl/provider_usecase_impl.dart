import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/domain/repositories/i_provider_repository.dart';
import 'package:controle_pedidos/src/modules/provider/domain/usecases/I_provider_usecase.dart';
import 'package:controle_pedidos/src/modules/provider/errors/provider_error.dart';
import 'package:dartz/dartz.dart';

class ProviderUsecaseImpl implements IProviderUsecase {
  final IProviderRepository _repository;

  ProviderUsecaseImpl(this._repository);

  @override
  Future<Either<ProviderError, Provider>> createProvider(
      Provider provider) async {
    if (provider.name.isEmpty || provider.name.length < 2) {
      return Left(ProviderError('Invalid name'));
    }

    if (provider.location.isEmpty) {
      return Left(ProviderError('Invalid location'));
    }

    return _repository.createProvider(provider);
  }

  @override
  Future<Either<ProviderError, Provider>> updateProvider(
      Provider provider) async {
    if (provider.id.isEmpty) {
      return Left(ProviderError('Invalid id'));
    }

    if (provider.name.isEmpty || provider.name.length < 2) {
      return Left(ProviderError('Invalid name'));
    }

    if (provider.location.isEmpty) {
      return Left(ProviderError('Invalid location'));
    }

    return _repository.updateProvider(provider);
  }

  @override
  Future<Either<ProviderError, Provider>> getProviderById(String id) async {
    if (id.isEmpty) {
      return Left(ProviderError('Invalid id'));
    }

    return _repository.getProviderById(id);
  }

  @override
  Future<Either<ProviderError, List<Provider>>> getProviderList() {
    return _repository.getProviderList();
  }

  @override
  Future<Either<ProviderError, List<Provider>>> getProviderListByEnabled() {
    return _repository.getProviderListByEnabled();
  }
}
