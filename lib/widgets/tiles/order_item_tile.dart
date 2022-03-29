import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({Key? key, required this.orderItem}) : super(key: key);

  final OrderItemData orderItem;

  @override
  Widget build(BuildContext context) {
    bool hasNote = false;

    if (orderItem.note != null) {
      hasNote = true;
    } else {
      hasNote = false;
    }

    return Card(
      color: CustomColors.backgroundTile,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  orderItem.quantity.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CustomColors.textColorTile),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  orderItem.product.category,
                  style: const TextStyle(color: CustomColors.textColorTile),
                )),
            Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: hasNote
                    ? Text(
                        orderItem.product.name + ' - ' + orderItem.note!,
                        style:
                            const TextStyle(color: CustomColors.textColorTile),
                      )
                    : Text(
                        orderItem.product.name,
                        style:
                            const TextStyle(color: CustomColors.textColorTile),
                      )),
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  orderItem.product.provider.name,
                  style: const TextStyle(color: CustomColors.textColorTile),
                )),
          ],
        ),
      ),
    );
  }
}
