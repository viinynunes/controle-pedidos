import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/tiles/transaction_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsDialog extends StatefulWidget {
  const TransactionsDialog(
      {Key? key,
      required this.product,
      required this.iniDate,
      required this.endDate})
      : super(key: key);

  final ProductData product;
  final DateTime iniDate, endDate;

  @override
  State<TransactionsDialog> createState() => _TransactionsDialogState();
}

class _TransactionsDialogState extends State<TransactionsDialog> {
  List<OrderData> orderList = [];
  bool loading = false;

  final dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();

    _updateOrderList();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width > 600;

    return AlertDialog(
      backgroundColor: CustomColors.backgroundColor,
      elevation: 50,
      title: Column(
        children: [
          Text(
            widget.product.name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.textColorTile),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(widget.iniDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColors.textColorTile.withOpacity(0.7)),
              ),
              Text(
                dateFormat.format(widget.endDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColors.textColorTile.withOpacity(0.7)),
              ),
            ],
          )
        ],
      ),
      content: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orderList.isEmpty
              ? const Center(
                  child: Text('Nenhum pedido encontrado', style: TextStyle(color: CustomColors.textColorTile),),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: desktop
                      ? MediaQuery.of(context).size.width * 0.4
                      : double.maxFinite,
                  child: ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      var order = orderList[index];

                      return TransactionListTile(order: order);
                    },
                  ),
                ),
    );
  }

  Future<void> _updateOrderList() async {
    if (mounted) {
      setState(() {
        loading = true;
      });

      final list = await OrderModel.of(context).getOrderListByProduct(
          widget.product, widget.iniDate, widget.endDate);

      setState(() {
        orderList.clear();
        orderList = list;
        loading = false;
      });
    }
  }
}
