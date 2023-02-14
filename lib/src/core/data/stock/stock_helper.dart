import '../../../domain/entities/product.dart';
import '../../../domain/models/stock_model.dart';
import '../../date_time_helper.dart';

class StockHelper {
  static String getStockCode({required Product product, required DateTime date}) {
    return product.id +
        product.provider.id +
        DateTime(date.year, date.month, date.day).toString();
  }

  static StockModel getNewStock(
      {required Product product,
      required DateTime date,
      int total = 0,
      int totalOrdered = 0}) {
    return StockModel(
        id: '0',
        code: getStockCode(product: product, date: date),
        total: total,
        totalOrdered: totalOrdered,
        registrationDate: DateTimeHelper.removeHourFromDateTime(date: date),
        product: product);
  }

  static mergeStockList({required List<StockModel> stockListFromDB}) {
    List<StockModel> stockList = [];

    for (var stock in stockListFromDB) {
      if (stockList.contains(stock)) {
        var stockFromList = stockList.singleWhere(
            (stockFromList) => stockFromList.product == stock.product);

        stockFromList.total += stock.total;
        stockFromList.totalOrdered += stock.totalOrdered;
      } else {
        stockList.add(stock);
      }
    }

    return stockList;
  }
}
