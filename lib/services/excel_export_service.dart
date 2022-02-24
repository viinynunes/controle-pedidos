import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../data/order_data.dart';

class ExcelExportService {
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

        rowIndex++;
      }

      if (rowIndex >= 6) {
        rowIndex = 1;
        columnIndex = columnIndex + 2;
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    _saveAndOpenFile(bytes);
  }

  void _saveAndOpenFile(List<int> bytes) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final fileName = '$path/ExcelExport.xlsx';
    final file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
