import 'package:dartz/dartz.dart';

import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';
import '../../errors/stock_error.dart';

abstract class ChangeStockProviderUsecase {
  Future<Either<StockError, Stock>> call(
      {required String stockID, required Provider newProvider});
}
