import 'package:controle_pedidos/src/domain/entities/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AndroidOrderItemRegistrationTile extends StatelessWidget {
  const AndroidOrderItemRegistrationTile(
      {Key? key,
      required this.item,
      required this.onRemove,
      required this.onEdit})
      : super(key: key);

  final OrderItem item;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      direction: Axis.vertical,
      endActionPane: ActionPane(
        dismissible: null,
        motion: const ScrollMotion(),
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SlidableAction(
                  onPressed: (e) => onRemove(),
                  icon: Icons.delete_forever,
                  backgroundColor: Colors.red,
                ),
                SlidableAction(
                  onPressed: (e) {},
                  icon: Icons.edit,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  item.quantity.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  item.product.category,
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Text(
                  item.product.name,
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  item.product.providerName,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
