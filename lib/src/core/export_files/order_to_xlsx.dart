import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../domain/entities/order.dart';

class OrderToXLSX {
  final _dateFormat = DateFormat('dd-MM-yyyy');

  void exportOrder(List<Order> orderList) {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];
    int rowIndex = 1, columnIndex = 1;

    Style orderItemStyle = workbook.styles.add('orderItemStyle');
    orderItemStyle.borders.all.lineStyle = LineStyle.thin;

    Style clientNameStyle = workbook.styles.add('clientNameStyle');
    clientNameStyle.borders.all.lineStyle = LineStyle.thin;
    clientNameStyle.hAlign = HAlignType.center;

    for (var order in orderList) {
      rowIndex++;
      sheet.getRangeByIndex(rowIndex, columnIndex).setText(order.client.name);
      sheet.getRangeByIndex(rowIndex, columnIndex).cellStyle = clientNameStyle;
      rowIndex++;
      for (var item in order.orderItemList) {
        if (item.note.isNotEmpty) {
          sheet.getRangeByIndex(rowIndex, columnIndex).setText(
              item.quantity.toString() +
                  ' ' +
                  item.product.category +
                  ' ' +
                  item.product.name +
                  ' - ' +
                  item.note);
        } else {
          sheet.getRangeByIndex(rowIndex, columnIndex).setText(
              item.quantity.toString() +
                  ' ' +
                  item.product.category +
                  ' ' +
                  item.product.name);
        }

        sheet.getRangeByIndex(rowIndex, columnIndex).cellStyle = orderItemStyle;

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

    _saveAndOpenFile(bytes, 'Pedidos ${_dateFormat.format(DateTime.now())}');
  }

  void _saveAndOpenFile(List<int> bytes, String name) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final fileName = '$path/$name.xlsx';
    final file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
