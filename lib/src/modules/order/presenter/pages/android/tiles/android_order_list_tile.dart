import 'package:controle_pedidos/src/domain/entities/order.dart';
import 'package:flutter/material.dart';

class AndroidOrderListTile extends StatelessWidget {
  const AndroidOrderListTile(
      {Key? key, required this.order, required this.onTap})
      : super(key: key);

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
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
                  child: Text(
                    order.client.name,
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.orderItemLength > 1
                          ? '${order.orderItemLength.toString()} Itens'
                          : '${order.orderItemLength.toString()} Item'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ListView(
                          children: order.orderItemList
                              .map((e) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                      e.toString(),
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                    ),
                              ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
