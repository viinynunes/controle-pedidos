import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/product.dart';

class AndroidProductStockDefaultTile extends StatelessWidget {
  const AndroidProductStockDefaultTile(
      {Key? key, required this.product, required this.onChecked})
      : super(key: key);

  final Product product;
  final VoidCallback onChecked;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: product.stockDefault,
      onChanged: (e) => onChecked(),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Text(product.name),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(product.category),
            ),
          ],
        ),
      ),
    );
  }
}
