import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../domain/models/report_establishment_model.dart';

class StockByEstablishmentToXLSX {
  exportReportByEstablishment(
      {required List<ReportEstablishmentModel> establishmentList}) {
    final workbook = Workbook(establishmentList.length);

    Style stockStyle = workbook.styles.add('stockStyle');
    stockStyle.borders.all.lineStyle = LineStyle.thin;

    Style providerStyle = workbook.styles.add('providerStyle');
    providerStyle.borders.all.lineStyle = LineStyle.thin;
    providerStyle.hAlign = HAlignType.center;

    for (int i = 0; i < establishmentList.length; i++) {
      final establishmentModel = establishmentList[i];

      var sheet = workbook.worksheets[i];
      sheet.name = establishmentModel.establishment.name;

      int rowIndex = 1, columnIndex = 1, columnInitValue = 1;

      for (final providerModel in establishmentModel.providerList) {
        rowIndex++;

        columnIndex = columnInitValue;

        _buildSheet(
            sheet: sheet,
            text: providerModel.provider.name,
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            style: providerStyle);
        columnIndex++;
        _buildSheet(
            sheet: sheet,
            text: 'Localização',
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            style: providerStyle);
        columnIndex++;
        _buildSheet(
            sheet: sheet,
            text: 'Total',
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            style: providerStyle);
        columnIndex++;
        _buildSheet(
            sheet: sheet,
            text: 'Pedido',
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            style: providerStyle);
        columnIndex++;
        _buildSheet(
            sheet: sheet,
            text: 'Sobra',
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            style: providerStyle);
        rowIndex++;

        for (final stock in providerModel.stockList) {
          columnIndex = columnInitValue;
          _buildSheet(
              sheet: sheet,
              text: stock.product.name,
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              style: stockStyle);

          columnIndex++;

          _buildSheet(
              sheet: sheet,
              text: stock.product.provider.location,
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              style: stockStyle);

          columnIndex++;

          _buildSheet(
              sheet: sheet,
              text: '${stock.product.category} ' '${stock.total.toString()}',
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              style: stockStyle);

          columnIndex++;

          _buildSheet(
              sheet: sheet,
              text: '${stock.product.category} '
                  '${stock.totalOrdered.toString()}',
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              style: stockStyle);

          columnIndex++;

          _buildSheet(
              sheet: sheet,
              text: '',
              numberText: stock.totalOrdered - stock.total,
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              style: stockStyle);
          rowIndex++;
          columnIndex = columnInitValue;

          sheet.autoFitColumn(columnInitValue);
        }

        if (rowIndex > 60) {
          rowIndex = 1;
          columnInitValue = columnInitValue + 6;
        }
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    _saveAndOpenFile(
        bytes, 'Relatório Final ${DateFormat().format(DateTime.now())}');
  }

  void _saveAndOpenFile(List<int> bytes, String name) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final fileName = '$path/$name.xlsx';
    final file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    final result = await OpenFile.open(fileName);

    result.type.name;
  }

  _buildSheet(
      {required Worksheet sheet,
      required String text,
      required int rowIndex,
      required columnIndex,
      required Style style,
      int? numberText}) {
    if (numberText != null) {
      sheet
          .getRangeByIndex(rowIndex, columnIndex)
          .setNumber(numberText.toDouble());
    } else {
      sheet.getRangeByIndex(rowIndex, columnIndex).setText(text);
    }

    sheet.getRangeByIndex(rowIndex, columnIndex).cellStyle = style;
    sheet.autoFitColumn(columnIndex);
  }
}
