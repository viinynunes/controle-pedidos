import 'package:controle_pedidos/src/domain/entities/order_item.dart';
import 'package:controle_pedidos/src/modules/order/presenter/stores/order_registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/widgets/add_remove_quantity_widget.dart';
import '../../../stores/order_registration_tile_controller.dart';

class AndroidOrderItemRegistrationTile extends StatefulWidget {
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
  State<AndroidOrderItemRegistrationTile> createState() =>
      _AndroidOrderItemRegistrationTileState();
}

class _AndroidOrderItemRegistrationTileState
    extends State<AndroidOrderItemRegistrationTile> {
  final registrationController = GetIt.I.get<OrderRegistrationController>();
  final tileController = GetIt.I.get<OrderRegistrationTileController>();

  @override
  void initState() {
    super.initState();

    reaction((p0) => registrationController.orderItemList, (p0) {
      tileController.initState(widget.item);
    });

    tileController.initState(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      direction: Axis.horizontal,
      startActionPane: ActionPane(
        dismissible: null,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (e) => widget.onRemove(),
            icon: Icons.delete_forever,
            backgroundColor: Colors.red,
          ),
          SlidableAction(
            onPressed: (e) {},
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
                        onTap: () => tileController.updateQuantity(true),
                        icon: Icons.add_circle_sharp,
                        color: Colors.green),
                    const SizedBox(height: 10),
                    AddRemoveQuantityWidget(
                        onTap: () => tileController.updateQuantity(false),
                        icon: Icons.remove_circle_sharp,
                        color: Colors.red),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Observer(
                  builder: (_) => Text(
                    tileController.quantity.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  widget.item.product.category,
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Text(
                  widget.item.note.isNotEmpty
                      ? '${widget.item.product.name} - ${widget.item.note}'
                      : widget.item.product.name,
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Text(
                  widget.item.product.providerName,
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
