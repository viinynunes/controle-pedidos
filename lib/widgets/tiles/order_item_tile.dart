import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class OrderItemTile extends StatefulWidget {
  const OrderItemTile(
      {Key? key, required this.orderItem, required this.onRefresh})
      : super(key: key);

  final OrderItemData orderItem;
  final VoidCallback onRefresh;

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  late bool hasNote;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.backgroundTile,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: hasNote
                    ? Text(
                        widget.orderItem.product.name +
                            ' - ' +
                            widget.orderItem.note!,
                        style:
                            const TextStyle(color: CustomColors.textColorTile),
                      )
                    : Text(
                        widget.orderItem.product.name,
                        style:
                            const TextStyle(color: CustomColors.textColorTile),
                      )),
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  widget.orderItem.product.provider.name,
                  style: const TextStyle(color: CustomColors.textColorTile),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  widget.orderItem.product.category,
                  style: const TextStyle(color: CustomColors.textColorTile),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  widget.orderItem.quantity.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CustomColors.textColorTile),
                )),
          ],
        ),
      ),
    );
  }
}
