import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
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
      await StockModel.of(context).createStockItem(stockData, () {});
    }
  }

  Future<void> addEmptyDuplicatedProductInStock(
      ProductData product, BuildContext context) async {
    StockData stock = StockData(0, 0, DateTime.now(), product);

    /*if (providerList.contains(product.provider)) {
      if (!stockListByProvider.contains(stock)) {
        await StockModel.of(context).createDuplicatedStockItem(stock);
      }
    } else {
      await StockModel.of(context).createDuplicatedStockItem(stock);
    }*/
    await StockModel.of(context).createDuplicatedStockItem(stock);
  }

  Future<void> loadEmptyProductsListInStock(BuildContext context) async {
    final list =
        await ProductModel.of(context).getEnabledProductsByStockDefaultTrue();

    for (var product in list) {
      StockData newStock = StockData(0, 0, DateTime.now(), product);

      StockModel.of(context).createStockItem(newStock, () {});
    }
  }

  Future<void> updateTotalOrderedInAllStockByProvider(
      BuildContext context, List<StockData> stockList, int left) async {
    for (var stock in stockList) {
      stock.totalOrdered = stock.total + left;
      StockModel.of(context).updateStockItem(stock, () {});
    }
  }

  Future<void> updateStockItem(
      BuildContext context, StockData stockItem) async {
    StockModel.of(context).updateStockItem(stockItem, () {});
  }

  Future<void> verifyStockTotal(
      BuildContext context, DateTime iniDate, DateTime endDate, ProviderData provider) async {
    /*final stockItemList =
        await StockModel.of(context).getStockBetweenDates(iniDate, endDate);*/

    final stockItemList = await StockModel.of(context).getAllStocksByDateAndProvider(iniDate, endDate, provider);

    for (var stock in stockItemList) {
      int totalOrdered = 0;

      final orderList = await OrderModel.of(context)
          .getOrderListByProduct(stock.product, iniDate, endDate);

      for (var order in orderList) {
        totalOrdered += order.orderItemList!.first.quantity;
      }

      if (totalOrdered != stock.total) {
        stock.total = totalOrdered;
        await StockModel.of(context).updateStockItem(stock, () {});
      }
    }
  }
}
