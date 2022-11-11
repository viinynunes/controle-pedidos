import 'package:controle_pedidos/src/domain/entities/stock.dart';

import '../i_stock_service.dart';

class StockServiceImpl implements IStockService {
  @override
  void sortStockListByProductName(List<Stock> stockList) {
    stockList.sort((a, b) =>
        a.product.name.toLowerCase().compareTo(b.product.name.toLowerCase()));
  }
}
