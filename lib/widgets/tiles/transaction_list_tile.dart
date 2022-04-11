import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({Key? key, required this.order}) : super(key: key);

  final OrderData order;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Card(
      elevation: 10,
      color: CustomColors.backgroundTile,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Text(
                dateFormat.format(order.creationDate),
                style: const TextStyle(
                  color: CustomColors.textColorTile,
                ),
              ),
            ),
            Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Text(
                  order.client.name,
                  style: const TextStyle(color: CustomColors.textColorTile),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  order.orderItemList!.first.product.category,
                  style: const TextStyle(color: CustomColors.textColorTile),
                  textAlign: TextAlign.right,
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  order.orderItemList!.first.quantity.toString(),
                  style: const TextStyle(color: CustomColors.textColorTile),
                  textAlign: TextAlign.right,
                )),
          ],
        ),
      ),
    );
  }
}
