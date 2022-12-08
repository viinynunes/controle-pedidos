import 'package:flutter/material.dart';

import '../../../stock/presenter/model/report_provider_model.dart';

class AndroidCustomProviderDataTable extends StatelessWidget {
  const AndroidCustomProviderDataTable(
      {Key? key,
      required this.provider,
      this.columnSpacing,
      required this.withMergeOptions})
      : super(key: key);

  final ReportProviderModel provider;
  final double? columnSpacing;
  final bool withMergeOptions;

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
        columns: [
          DataColumn(
            label: SizedBox(
              width: size.width * 0.4,
              child: provider.merge
                  ? TextField(
                      decoration: InputDecoration(
                          hintText: 'Nomeie a tabela',
                          hintStyle: Theme.of(context).textTheme.bodySmall),
                    )
                  : withMergeOptions
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                '${provider.providerName} - ${provider.providerLocation}',
                              ),
                            ),
                            const Flexible(
                                child: Center(child: Text('Produto')))
                          ],
                        )
                      : const Center(child: Text('Produto')),
            ),
          ),
          DataColumn(
              label: provider.merge
                  ? ConstrainedBox(
                      constraints: BoxConstraints(minWidth: size.width * 0.1),
                      child: const Text('Local'))
                  : Container()),
          const DataColumn(label: Text('Emb')),
          const DataColumn(label: Text('Total'), numeric: true),
          const DataColumn(label: Text('Sobra'), numeric: true),
        ],
        rows: provider.stockList
            .map(
              (stock) => DataRow(
                cells: [
                  DataCell(Container(
                    width: size.width * 0.4,
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      stock.product.name,
                      maxLines: 1,
                    ),
                  )),
                  DataCell(provider.merge
                      ? Text(
                          stock.product.provider!.location,
                          textAlign: TextAlign.left,
                        )
                      : Container()),
                  DataCell(Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(stock.product.category),
                  )),
                  DataCell(Text(stock.totalOrdered.toString())),
                  DataCell(Text(
                    '${(stock.totalOrdered - stock.total)}',
                  )),
                ],
              ),
            )
            .toList());
  }
}
