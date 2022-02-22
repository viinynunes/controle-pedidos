import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/utils/transform_widget_to_image.dart';
import 'package:controle_pedidos/utils/widget_to_image.dart';
import 'package:flutter/material.dart';


class ReportOneOrderPage extends StatefulWidget {
  const ReportOneOrderPage({Key? key, required this.order}) : super(key: key);

  final OrderData order;

  @override
  _ReportOneOrderPageState createState() => _ReportOneOrderPageState();
}

class _ReportOneOrderPageState extends State<ReportOneOrderPage> {

  late GlobalKey key1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.order.client.name),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await TransformWidgetToImage.getWidget(key1, widget.order.client.name);
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: WidgetToImage(
          builder: (key) {
            key1 = key;
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Center(
                    child: Text(
                      widget.order.client.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Flexible(
                    child: ListView.builder(
                      itemCount: widget.order.orderItemList!.length,
                      itemBuilder: (context, index) {
                        var item = widget.order.orderItemList![index];
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
              ),
            );
          },
        ));
  }
}
