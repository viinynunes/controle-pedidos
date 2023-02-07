import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/product.dart';

class AndroidProductStockDefaultTile extends StatelessWidget {
  const AndroidProductStockDefaultTile({
    Key? key,
    required this.productList,
    required this.onChanged,
  }) : super(key: key);

  final List<Product> productList;
  final Function(Product product) onChanged;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: width * 0.1,
        columns: const [
          DataColumn(
            label: Text('Produto'),
          ),
          DataColumn(
            label: Text('Embalagem'),
          ),
          DataColumn(
            label: Text('Fixo'),
          ),
        ],
        rows: productList
            .map((product) => DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: width * 0.3,
                        child: AutoSizeText(
                          product.name,
                          maxLines: 2,
                          minFontSize: 5,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * .1,
                        child: AutoSizeText(
                          product.category,
                          minFontSize: 5,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * .1,
                        child: Checkbox(
                          value: product.stockDefault,
                          onChanged: (_) => onChanged(product),
                        ),
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
