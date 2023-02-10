import 'package:controle_pedidos/src/domain/entities/establishment.dart';
import 'package:controle_pedidos/src/modules/establishment/errors/establishment_info_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IEstablishmentUsecase {
  Future<Either<EstablishmentInfoException, Establishment>> createEstablishment(
      Establishment establishment);

  Future<Either<EstablishmentInfoException, Establishment>> updateEstablishment(
      Establishment establishment);

  Future<Either<EstablishmentInfoException, Establishment>> getEstablishmentById(
      String id);

  Future<Either<EstablishmentInfoException, List<Establishment>>>
      getEstablishmentList();

  Future<Either<EstablishmentInfoException, List<Establishment>>>
      getEstablishmentListByEnabled();
}
