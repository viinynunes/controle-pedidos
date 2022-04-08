import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:flutter/material.dart';

class ReportEstablishmentService {
  Future<List<StockData>> mergeOrderItemsByProvider(
      BuildContext context, DateTime iniDate, DateTime endDate) async {
    List<StockData> stockDataList = [];

    final stockList =
        await StockModel.of(context).getStockBetweenDates(iniDate, endDate);

    for (var item in stockList) {
      if (stockDataList.contains(item)) {
        var e = stockDataList
            .singleWhere((element) => element.product.id == item.product.id);
        if (e.product.provider == item.product.provider) {
          item.total += e.total;
          item.totalOrdered += e.totalOrdered;
          stockDataList.remove(e);
        }
      }
      stockDataList.add(item);
    }

    stockDataList.sort((a, b) {
      int firstCompare = a.product.provider.establishment.registrationDate
          .compareTo(b.product.provider.establishment.registrationDate);

      if (firstCompare == 0) {
        int compare = a.product.provider.registrationDate
            .compareTo(b.product.provider.registrationDate);

        if (compare == 0) {
          int secondCompare = a.product.provider.location
              .toLowerCase()
              .compareTo(b.product.provider.location.toLowerCase());

          if (secondCompare == 0) {
            return a.product.name
                .toLowerCase()
                .compareTo(b.product.name.toLowerCase());
          } else {
            return secondCompare;
          }
        } else {
          return compare;
        }
      } else {
        return firstCompare;
      }
    });

    return stockDataList;
  }
}
