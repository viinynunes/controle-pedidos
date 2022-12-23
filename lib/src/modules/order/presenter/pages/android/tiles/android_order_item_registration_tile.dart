import 'package:controle_pedidos/src/domain/entities/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../core/widgets/add_remove_quantity_widget.dart';

class AndroidOrderItemRegistrationTile extends StatelessWidget {
  const AndroidOrderItemRegistrationTile(
      {Key? key,
      required this.item,
      required this.onRemove,
      required this.onEdit,
      required this.increaseQuantity,
      required this.decreaseQuantity})
      : super(key: key);

  final OrderItem item;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  final VoidCallback increaseQuantity;
  final VoidCallback decreaseQuantity;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      direction: Axis.horizontal,
      endActionPane: ActionPane(
        dismissible: null,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onRemove(),
            icon: Icons.delete_forever,
            backgroundColor: Colors.red,
          ),
          SlidableAction(
            onPressed: (_) => onEdit(),
            icon: Icons.edit,
            backgroundColor: Theme.of(context).primaryColor,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddRemoveQuantityWidget(
                        onTap: increaseQuantity,
                        icon: Icons.add_circle_sharp,
                        color: Colors.green),
                    const SizedBox(height: 10),
                    AddRemoveQuantityWidget(
                        onTap: decreaseQuantity,
                        icon: Icons.remove_circle_sharp,
                        color: Colors.red),
                  ],
                ),
              ),
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
                flex: 4,
                fit: FlexFit.tight,
                child: Text(
                  item.note.isNotEmpty
                      ? '${item.product.name} - ${item.note}'
                      : item.product.name,
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Text(
                  item.product.provider.name,
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
