import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({Key? key, required this.order, required this.showOrderRegistrationPage}) : super(key: key);

  final OrderData order;
  final VoidCallback showOrderRegistrationPage;

  @override
  Widget build(BuildContext context) {

    final dateFormat = DateFormat('dd-MM-yyyy');

    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        showOrderRegistrationPage();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 3, 2, 3),
        child: Container(
          color: CustomColors.backgroundTile,
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
                  order.lengthOrderItemList.toString(),
                  style: _getStyle(),
                ),
              ),
              const Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  size: 16,
                  color: CustomColors.textColorTile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: CustomColors.textColorTile
    );
  }
}
