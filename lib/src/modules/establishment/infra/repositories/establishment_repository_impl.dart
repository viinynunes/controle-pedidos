import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/repositories/i_establishment_repository.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_errors.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/datasources/i_establishment_datasource.dart';
import 'package:controle_pedidos/src/modules/establishment/infra/models/establish_model.dart';
import 'package:dartz/dartz.dart';

class EstablishmentRepositoryImpl implements IEstablishmentRepository {
  final IEstablishmentDatasource _datasource;

  EstablishmentRepositoryImpl(this._datasource);

  @override
  Future<Either<EstablishmentError, bool>> createEstablishment(
      Establishment establishment) async {
    try {
      final result = await _datasource.createEstablishment(
          EstablishmentModel.fromEstablishment(establishment: establishment));

      return Right(result);
    } catch (e) {
      return Left(EstablishmentError(e.toString()));
    }
  }

  @override
  Future<Either<EstablishmentError, bool>> updateEstablishment(
      Establishment establishment) async {
    try {
      final result = await _datasource.updateEstablishment(
          EstablishmentModel.fromEstablishment(establishment: establishment));

      return Right(result);
    } catch (e) {
      return Left(EstablishmentError(e.toString()));
    }
  }

  @override
  Future<Either<EstablishmentError, List<Establishment>>>
      getEstablishmentList() async {
    try {
      final result = await _datasource.getEstablishmentList();

      return Right(result);
    } catch (e) {
      return Left(EstablishmentError(e.toString()));
    }
  }

  @override
  Future<Either<EstablishmentError, List<Establishment>>>
      getEstablishmentListByEnabled() async {
    try {
      final result = await _datasource.getEstablishmentListByEnabled();

      return Right(result);
    } catch (e) {
      return Left(EstablishmentError(e.toString()));
    }
  }
}
