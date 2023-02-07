import '../../../domain/entities/stock.dart';

abstract class IStockService {
  void sortStockListByProductName(List<Stock> stockList);

  void sortStockListByProviderAndProductName(List<Stock> stockList);

}
