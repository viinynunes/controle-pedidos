import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/report_provider_model.dart';

class AndroidCustomProviderDataTable extends StatelessWidget {
  const AndroidCustomProviderDataTable({
    Key? key,
    required this.providerModel,
    this.columnSpacing,
    required this.withMergeOptions,
    required this.blackFontColor,
  }) : super(key: key);

  final ReportProviderModel providerModel;
  final double? columnSpacing;
  final bool withMergeOptions;
  final bool blackFontColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DataTable(
        horizontalMargin: 0,
        showBottomBorder: true,
        columnSpacing: columnSpacing ?? 0,
        dataRowHeight: 20,
        headingRowHeight: 40,
        headingTextStyle: Theme.of(context).textTheme.titleMedium,
        border: const TableBorder(
            bottom: BorderSide(color: Colors.black, width: 0.3),
            horizontalInside: BorderSide(color: Colors.black, width: 0.3)),
        columns: [
          DataColumn(
            label: SizedBox(
              width: size.width * 0.4,
              child: providerModel.merge
                  ? TextField(
                      decoration: InputDecoration(
                        label: AutoSizeText(
                          'Nomeie a tabela',
                          maxLines: 1,
                          minFontSize: 5,
                          style: TextStyle(
                              color:
                                  blackFontColor ? Colors.black : Colors.white),
                        ),
                      ),
                      style: TextStyle(
                          color: blackFontColor ? Colors.black : Colors.white),
                    )
                  : withMergeOptions
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: Text(
                                  providerModel.provider.name,
                                  style: TextStyle(
                                      color: blackFontColor
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  providerModel.provider.location,
                                  style: TextStyle(
                                      color: blackFontColor
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                          'Produto',
                          style: TextStyle(
                              color:
                                  blackFontColor ? Colors.black : Colors.white),
                        )),
            ),
          ),
          DataColumn(
              label: providerModel.merge
                  ? ConstrainedBox(
                      constraints: BoxConstraints(minWidth: size.width * 0.1),
                      child: Text(
                        'Local',
                        style: TextStyle(
                            color:
                                blackFontColor ? Colors.black : Colors.white),
                      ),
                    )
                  : Container()),
          DataColumn(
              label: Text(
            'Emb',
            style:
                TextStyle(color: blackFontColor ? Colors.black : Colors.white),
          )),
          DataColumn(
              label: Text(
                'Total',
                style: TextStyle(
                    color: blackFontColor ? Colors.black : Colors.white),
              ),
              numeric: true),
          DataColumn(
              label: Text(
                'Sobra',
                style: TextStyle(
                    color: blackFontColor ? Colors.black : Colors.white),
              ),
              numeric: true),
        ],
        rows: providerModel.stockList
            .map(
              (stock) => DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: size.width * 0.4,
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        stock.product.name,
                        style: TextStyle(
                            color:
                                blackFontColor ? Colors.black : Colors.white, fontSize: 13),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  DataCell(
                    Visibility(
                      visible: providerModel.merge,
                      child: Text(
                        stock.product.provider.location,
                        maxLines: 1,
                        style: TextStyle(
                            color: blackFontColor ? Colors.black : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  DataCell(Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      stock.product.category,
                      style: TextStyle(
                          color: blackFontColor ? Colors.black : Colors.white),
                    ),
                  )),
                  DataCell(Text(
                    stock.totalOrdered.toString(),
                    style: TextStyle(
                        color: blackFontColor ? Colors.black : Colors.white),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${(stock.totalOrdered - stock.total)}',
                      style: TextStyle(
                          color: blackFontColor ? Colors.black : Colors.white),
                    ),
                  )),
                ],
              ),
            )
            .toList());
  }
}
