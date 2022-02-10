import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:flutter/material.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({Key? key, required this.orderItem}) : super(key: key);

  final OrderItemData orderItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(flex: 4, fit: FlexFit.tight, child: Text(orderItem.product.name)),
            Flexible(flex: 3, fit: FlexFit.tight, child: Text(orderItem.product.category)),
            Flexible(flex: 2, fit: FlexFit.tight, child: Text(orderItem.product.provider.name)),
            Flexible(flex: 1, fit: FlexFit.tight, child: Text(orderItem.quantity.toString())),
          ],
        ),
      ),
    );
  }
}
