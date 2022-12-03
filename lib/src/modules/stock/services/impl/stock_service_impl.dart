import 'package:controle_pedidos/src/domain/entities/stock.dart';

import '../i_stock_service.dart';

class StockServiceImpl implements IStockService {
  @override
  void sortStockListByProductName(List<Stock> stockList) {
    stockList.sort((a, b) =>
        a.product.name.toLowerCase().compareTo(b.product.name.toLowerCase()));
  }

  @override
  void sortStockListByProviderAndProductName(List<Stock> stockList) {
    stockList.sort((a, b) {
      int result = a.product.provider!.name
          .toLowerCase()
          .compareTo(b.product.provider!.name.toLowerCase());

      if (result == 0) {
        return a.product.name
            .toLowerCase()
            .compareTo(b.product.name.toLowerCase());
      } else {
        return result;
      }
    });
  }
}
