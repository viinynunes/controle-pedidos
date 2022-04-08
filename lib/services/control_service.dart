import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:flutter/material.dart';

class ControlService {
  Future<void> addEmptyProductInStock(ProductData product, BuildContext context,
      DateTime iniDate, DateTime endDate) async {
    final list =
        await StockModel.of(context).getStockBetweenDates(iniDate, endDate);

    StockData stockData = StockData(0, 0, DateTime.now(), product);

    if (!list.contains(stockData)) {
      await StockModel.of(context).createStockItem(stockData);
    }
  }

  Future<void> addEmptyDuplicatedProductInStock(
      ProductData product,
      List<ProviderData> providerList,
      List<StockData> stockListByProvider,
      BuildContext context) async {
    StockData stock = StockData(0, 0, DateTime.now(), product);

    if (providerList.contains(product.provider)) {
      if (!stockListByProvider.contains(stock)) {
        await StockModel.of(context).createDuplicatedStockItem(stock);
      }
    } else {
      await StockModel.of(context).createDuplicatedStockItem(stock);
    }
  }

  Future<void> loadEmptyProductsListInStock(BuildContext context) async {
    final list =
        await ProductModel.of(context).getEnabledProductsByStockDefaultTrue();

    for (var product in list) {
      StockData newStock = StockData(0, 0, DateTime.now(), product);

      await StockModel.of(context).createStockItem(newStock);
    }
  }

  Future<void> updateTotalOrderedInAllStockByProvider(
      BuildContext context, List<StockData> stockList, int left) async {
    for (var stock in stockList) {
      stock.totalOrdered = stock.total + left;
      await StockModel.of(context).updateStockItem(stock, () {});
    }
  }

  Future<void> updateStockItem(
      BuildContext context, StockData stockItem) async {
    StockModel.of(context).updateStockItem(stockItem, () {});
  }
}
