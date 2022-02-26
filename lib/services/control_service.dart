import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
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
}
