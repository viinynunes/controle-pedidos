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
    ///product list is empty when selecting provider
    return ListView(children: [
      DataTable(
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
                      Text(
                        product.name,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    DataCell(
                        Text(product.category, textAlign: TextAlign.center)),
                    DataCell(
                      Checkbox(
                        value: product.stockDefault,
                        onChanged: (_) => onChanged(product),
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    ]);
  }
}
