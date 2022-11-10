import 'package:controle_pedidos/src/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class AndroidOrderListTile extends StatelessWidget {
  const AndroidOrderListTile(
      {Key? key,
      required this.order,
      required this.onTap,
      required this.onDisable})
      : super(key: key);

  final Order order;
  final VoidCallback onTap;
  final VoidCallback onDisable;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDisable(),
            backgroundColor: Theme.of(context).errorColor,
            icon: Icons.delete_forever,
          )
        ],
      ),
      child: Ink(
        child: InkWell(
          onTap: onTap,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.client.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          order.orderItemLength > 1
                              ? '${order.orderItemLength.toString()} Itens'
                              : '${order.orderItemLength.toString()} Item',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          dateFormat.format(order.registrationDate),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ListView(
                        children: order.orderItemList
                            .map((e) => Text(
                                  e.toString(),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
