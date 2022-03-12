import 'dart:io';

import 'package:controle_pedidos/data/provider_data.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../data/order_data.dart';
import '../data/stock_data.dart';

class ExcelExportService {
  final dateFormat = DateFormat('dd-MM-yyyy');

  void createAndOpenExcelToOrder(List<OrderData> orderList) async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];
    int rowIndex = 1, columnIndex = 1;

    for (var order in orderList) {
      rowIndex++;
      sheet.getRangeByIndex(rowIndex, columnIndex).setText(order.client.name);
      rowIndex++;
      for (var item in order.orderItemList!) {
        if (item.note != null) {
          sheet.getRangeByIndex(rowIndex, columnIndex).setText(
              item.quantity.toString() +
                  ' ' +
                  item.product.category +
                  ' ' +
                  item.product.name +
                  ' ' +
                  item.note!);
        } else {
          sheet.getRangeByIndex(rowIndex, columnIndex).setText(
              item.quantity.toString() +
                  ' ' +
                  item.product.category +
                  ' ' +
                  item.product.name);
        }

        sheet.autoFitColumn(columnIndex);
        rowIndex++;
      }

      if (rowIndex >= 60) {
        rowIndex = 1;
        columnIndex = columnIndex + 2;
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    _saveAndOpenFile(bytes, 'pedidos ${dateFormat.format(DateTime.now())}');
  }

  void createAndOpenExcelToEstablishment(List<StockData> stockList) async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];

    int rowIndex = 1, columnIndex = 1, columnInitValue = 1;
    ProviderData? lastProvider;

    bool firstLine = true;

    for (var stockItem in stockList) {
      rowIndex++;
      columnIndex = columnInitValue;

      if(firstLine){
        sheet.getRangeByIndex(rowIndex, columnIndex).setText(stockItem.product.provider.name);
        rowIndex++;
        firstLine = false;
      }

      lastProvider ??= stockItem.product.provider;
      if (lastProvider != stockItem.product.provider) {
        rowIndex++;
        lastProvider = stockItem.product.provider;
        sheet.getRangeByIndex(rowIndex, columnIndex).setText(lastProvider.name);
        rowIndex++;
      }
      sheet
          .getRangeByIndex(rowIndex, columnIndex)
          .setText(stockItem.product.name);

      columnIndex++;

      sheet.getRangeByIndex(rowIndex, columnIndex)
      .setText(lastProvider.location);

      columnIndex++;

      sheet.getRangeByIndex(rowIndex, columnIndex).setText(
          stockItem.product.category +
              '   ' +
              stockItem.total.toString());

      columnIndex++;
      sheet.getRangeByIndex(rowIndex, columnIndex).setText(
          stockItem.product.category +
              '   ' +
              stockItem.totalOrdered.toString());

      columnIndex++;
      sheet
          .getRangeByIndex(rowIndex, columnIndex)
          .setText((stockItem.totalOrdered - stockItem.total).toString());

      sheet.autoFitColumn(columnInitValue);
      if (rowIndex > 60) {
        rowIndex = 1;
        columnInitValue = columnInitValue + 6;
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    _saveAndOpenFile(
        bytes, 'Relatório Final ${dateFormat.format(DateTime.now())}');
  }

  void _saveAndOpenFile(List<int> bytes, String name) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final fileName = '$path/$name.xlsx';
    final file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
