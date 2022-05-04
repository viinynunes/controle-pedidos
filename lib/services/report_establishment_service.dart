import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
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
        var list = stockDataList
            .where((element) => element.product.id == item.product.id)
            .toList();
        late StockData e;
        if (list.length == 1) {
          e = list
              .singleWhere((element) => element.product.id == item.product.id);
        } else if (list.length > 1) {
          for (var aux in list) {
            if (aux.product.provider.id == item.product.provider.id) {
              e = list.singleWhere((element) =>
                  element.product.id == item.product.id &&
                  element.product.provider.id == item.product.provider.id);
              break;
            } else {
              final auxProd = ProductData();
              auxProd.provider = ProviderData();
              auxProd.provider.name = '';
              auxProd.provider.location = '';
              auxProd.provider.registrationDate = DateTime.now();
              auxProd.provider.enabled = true;
              auxProd.provider.establishment = EstablishmentData();
              e = StockData(0, 0, DateTime.now(), auxProd);
            }
          }
        }

        if (e.product.provider == item.product.provider) {
          item.total += e.total;
          item.totalOrdered += e.totalOrdered;
          stockDataList.removeWhere((element) =>
              element.product.id == e.product.id &&
              element.product.provider.id == e.product.provider.id);
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
