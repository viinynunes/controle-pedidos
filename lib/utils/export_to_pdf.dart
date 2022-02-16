import 'dart:io';

import 'package:controle_pedidos/data/order_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportToPDF {
  static Future<void> createPDF(List<OrderData> list) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.ListView.builder(
              itemBuilder: (context, index) {
                var order = list[index];
                return pw.Column(
                  children: [
                    pw.Text(order.client.name),
                    pw.ListView.builder(
                        itemBuilder: (context, index) {
                          var item = order.orderItemList![index];
                          return pw.Text(
                              '${item.quantity} ${item.product.category} ${item.product.name}');
                        },
                        itemCount: order.orderItemList!.length),
                    pw.SizedBox(height: 10),
                  ],
                );
              },
              itemCount: list.length);
        },
      ),
    );

    saveFileAndLaunchFile(pdf, 'Output.pdf');
  }

  static Future<void> saveFileAndLaunchFile(
      pw.Document pdf, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(await pdf.save());
    OpenFile.open('$path/$fileName');
  }
}
