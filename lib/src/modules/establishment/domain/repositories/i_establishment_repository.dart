import 'package:controle_pedidos/src/modules/establishment/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_errors.dart';
import 'package:dartz/dartz.dart';

abstract class IEstablishmentRepository {
  Future<Either<EstablishmentError, Establishment>> createEstablishment(
      Establishment establishment);

  Future<Either<EstablishmentError, Establishment>> updateEstablishment(
      Establishment establishment);

  Future<Either<EstablishmentError, Establishment>> getEstablishmentById(
      String id);

  Future<Either<EstablishmentError, List<Establishment>>>
      getEstablishmentList();

  Future<Either<EstablishmentError, List<Establishment>>>
      getEstablishmentListByEnabled();
}
