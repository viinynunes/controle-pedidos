import 'package:controle_pedidos/data/order_data.dart';
import 'package:flutter/material.dart';

class ReportOneOrderPage extends StatelessWidget {
  const ReportOneOrderPage({Key? key, required this.order}) : super(key: key);

  final OrderData order;

  @override
  Widget build(BuildContext context) {

    final _widgetKey = GlobalKey();

    return Scaffold(
        appBar: AppBar(
          title: Text(order.client.name),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: Column(
          key: _widgetKey,
          children: [
            const SizedBox(height: 20,),
            Center(
              child: Text(
                order.client.name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10,),
            Flexible(
              child: ListView.builder(
                itemCount: order.orderItemList!.length,
                itemBuilder: (context, index) {
                  var item = order.orderItemList![index];
                  String note = item.note ?? '';
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(item.quantity.toString() +
                            ' ' +
                            item.product.category +
                            ' ' +
                            item.product.name +
                            ' - ' +
                            note, style: const TextStyle(fontSize: 16),),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ));
  }
}
