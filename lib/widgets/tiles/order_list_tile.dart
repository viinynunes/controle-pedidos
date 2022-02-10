import 'package:controle_pedidos/data/order_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({Key? key, required this.order}) : super(key: key);

  final OrderData order;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        dismissible: null,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (e) {},
            icon: Icons.delete_forever,
            backgroundColor: Colors.red,
            label: 'Apagar',
          ),
          SlidableAction(
            onPressed: (e) {},
            icon: Icons.edit,
            backgroundColor: Colors.deepPurple,
            label: 'Editar',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Text(
                  order.creationDate.toString(),
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  order.client.name,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  order.orderItemList!.length.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
