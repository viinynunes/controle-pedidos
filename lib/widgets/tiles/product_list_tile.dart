import 'package:controle_pedidos/data/product_data.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({Key? key, required this.product}) : super(key: key);

  final ProductData product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    product.category,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    product.provider.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
