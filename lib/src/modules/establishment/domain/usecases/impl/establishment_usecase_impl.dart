import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/repositories/i_establishment_repository.dart';
import 'package:controle_pedidos/src/modules/establishment/domain/usecases/i_establishment_usecase.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_errors.dart';
import 'package:dartz/dartz.dart';

class EstablishmentUsecaseImpl implements IEstablishmentUsecase {
  final IEstablishmentRepository _repository;

  EstablishmentUsecaseImpl(this._repository);

  @override
  Future<Either<EstablishmentError, bool>> createEstablishment(
      Establishment establishment) async {
    if (establishment.name.isEmpty || establishment.name.length < 2) {
      return Left(EstablishmentError('Invalid name'));
    }

    return _repository.createEstablishment(establishment);
  }

  @override
  Future<Either<EstablishmentError, bool>> updateEstablishment(
      Establishment establishment) async {
    if (establishment.id.isEmpty) {
      return Left(EstablishmentError('Invalid id'));
    }

    if (establishment.name.isEmpty || establishment.name.length < 2) {
      return Left(EstablishmentError('Invalid name'));
    }

    return _repository.updateEstablishment(establishment);
  }

  @override
  Future<Either<EstablishmentError, List<Establishment>>>
      getEstablishmentList() async {
    return _repository.getEstablishmentList();
  }
}
