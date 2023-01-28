import 'dart:async';

import 'package:controle_pedidos/src/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class AndroidOrderListTile extends StatefulWidget {
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
  State<AndroidOrderListTile> createState() => _AndroidOrderListTileState();
}

class _AndroidOrderListTileState extends State<AndroidOrderListTile> {
  final dateFormat = DateFormat('dd-MM-yyyy');
  final scrollController = ScrollController();

  scrollListToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.elasticOut);
    } else {
      Timer(const Duration(milliseconds: 400), () => scrollListToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollListToBottom());

    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onDisable(),
            icon: Icons.delete,
            backgroundColor: Theme.of(context).errorColor,
            autoClose: false,
            borderRadius: BorderRadius.circular(50),
            spacing: 10,
          )
        ],
      ),
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
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
                        widget.order.client.name,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        widget.order.orderItemList.length > 1
                            ? '${widget.order.orderItemList.length.toString()} Itens'
                            : '${widget.order.orderItemList.length.toString()} Item',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        dateFormat.format(widget.order.registrationDate),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.057,
                    child: ListView(
                      controller: scrollController,
                      reverse: true,
                      children: widget.order.orderItemList
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
    );
  }
}
