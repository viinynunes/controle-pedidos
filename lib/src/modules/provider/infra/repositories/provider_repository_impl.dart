import 'package:controle_pedidos/src/modules/provider/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/domain/repositories/i_provider_repository.dart';
import 'package:controle_pedidos/src/modules/provider/errors/provider_error.dart';
import 'package:controle_pedidos/src/modules/provider/infra/datasources/i_provider_datasource.dart';
import 'package:controle_pedidos/src/modules/provider/infra/models/provider_model.dart';
import 'package:dartz/dartz.dart';

class ProviderRepositoryImpl implements IProviderRepository {
  final IProviderDatasource _datasource;

  ProviderRepositoryImpl(this._datasource);

  @override
  Future<Either<ProviderError, bool>> createProvider(Provider provider) async {
    try {
      final result = await _datasource
          .createProvider(ProviderModel.fromProvider(provider));

      return Right(result);
    } catch (e) {
      return Left(ProviderError(e.toString()));
    }
  }

  @override
  Future<Either<ProviderError, bool>> updateProvider(Provider provider) async {
    try {
      final result = await _datasource
          .updateProvider(ProviderModel.fromProvider(provider));

      return Right(result);
    } catch (e) {
      return Left(ProviderError(e.toString()));
    }
  }

  @override
  Future<Either<ProviderError, List<Provider>>> getProviderList() async {
    try {
      final result = await _datasource.getProviderList();

      return Right(result);
    } catch (e) {
      return Left(ProviderError(e.toString()));
    }
  }
}
