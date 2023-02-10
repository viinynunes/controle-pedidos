import 'package:controle_pedidos/src/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/repositories/i_establishment_repository.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/usecases/i_establishment_usecase.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_errors.dart';
import 'package:dartz/dartz.dart';

class EstablishmentUsecaseImpl implements IEstablishmentUsecase {
  final IEstablishmentRepository _repository;

  EstablishmentUsecaseImpl(this._repository);

  @override
  Future<Either<EstablishmentError, Establishment>> createEstablishment(
      Establishment establishment) async {
    if (establishment.name.isEmpty || establishment.name.length < 2) {
      return Left(EstablishmentError('Nome inválido'));
    }

    return _repository.createEstablishment(establishment);
  }

  @override
  Future<Either<EstablishmentError, Establishment>> updateEstablishment(
      Establishment establishment) async {
    if (establishment.id.isEmpty) {
      return Left(EstablishmentError('ID inválido'));
    }

    if (establishment.name.isEmpty || establishment.name.length < 2) {
      return Left(EstablishmentError('Nome inválido'));
    }

    return _repository.updateEstablishment(establishment);
  }

  @override
  Future<Either<EstablishmentError, Establishment>> getEstablishmentById(
      String id) async {
    if (id.isEmpty) {
      return Left(EstablishmentError('ID inválido'));
    }

    return _repository.getEstablishmentById(id);
  }

  @override
  Future<Either<EstablishmentError, List<Establishment>>>
      getEstablishmentList() {
    return _repository.getEstablishmentList();
  }

  @override
  Future<Either<EstablishmentError, List<Establishment>>>
      getEstablishmentListByEnabled() {
    return _repository.getEstablishmentListByEnabled();
  }
}
