import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/pages/order/order_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({Key? key, required this.order}) : super(key: key);

  final OrderData order;

  @override
  Widget build(BuildContext context) {

    void _showOrderRegistrationPage(OrderData order) async {
      final recOrder = await Navigator.push(context, MaterialPageRoute(builder: (context) => OrderRegistrationPage(order: order,)));
    }

    final dateFormat = DateFormat('dd-MM-yyyy - HH:mm');
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
            onPressed: (e) {
              _showOrderRegistrationPage(order);
            },
            icon: Icons.edit,
            backgroundColor: Colors.deepPurple,
            label: 'Editar',
          ),
        ],
      ),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        onTap: () {
          _showOrderRegistrationPage(order);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 3, 2, 3),
          child: Container(
            color: Colors.grey.withOpacity(0.2),
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text(
                    dateFormat.format(order.creationDate),
                    style: _getStyle(),
                  ),
                ),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Text(
                    order.client.name,
                    style: _getStyle(),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    order.orderItemList!.length.toString(),
                    style: _getStyle(),
                  ),
                ),
                const Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _getStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }
}
