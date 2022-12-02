import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../domain/entities/order.dart';

class OrderReportModalBottomMenu extends StatelessWidget {
  const OrderReportModalBottomMenu(
      {Key? key,
      this.order,
      required this.onGenerateImage,
      required this.onGeneratePDF,
      required this.onGenerateXLSX})
      : super(key: key);

  final Order? order;
  final VoidCallback onGenerateImage;
  final VoidCallback onGeneratePDF;
  final VoidCallback onGenerateXLSX;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            order != null
                ? Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            order!.client.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      Text(dateFormat.format(order!.registrationDate)),
                      ListTile(
                        onTap: onGenerateImage,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image,
                            ),
                          ],
                        ),
                        title: const Text('Gerar Imagem'),
                        subtitle: const Text('Gera uma imagem em formato PNG'),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            ListTile(
              onTap: onGeneratePDF,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.picture_as_pdf,
                  ),
                ],
              ),
              title: const Text('Gerar PDF'),
              subtitle: const Text('Gera um arquivo em formato PDF'),
            ),
            const Divider(),
            order != null
                ? Container()
                : ListTile(
                    onTap: onGenerateXLSX,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.file_present,
                        ),
                      ],
                    ),
                    title: const Text('Gerar XLSX'),
                    subtitle:
                        const Text('Gera um arquivo em formato XLSX (Excel)'),
                  ),
          ],
        ),
      ),
    );
  }
}
