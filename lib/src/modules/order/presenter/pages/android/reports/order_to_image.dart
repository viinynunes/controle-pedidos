import 'package:controle_pedidos/src/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widget_to_image/repaint_boundary_widget_key.dart';
import '../../../../../core/widget_to_image/transform_widget_to_image.dart';
import 'order_report_modal_bottom_menu.dart';

class OrderToImage extends StatefulWidget {
  const OrderToImage({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  State<OrderToImage> createState() => _OrderToImageState();
}

class _OrderToImageState extends State<OrderToImage> {
  late GlobalKey repaintKey;
  bool share = false;
  final dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: RepaintBoundaryWidgetKey(
            builder: (key) {
              repaintKey = key;
              share = true;
              return Center(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      size.width * 0.15, 0, size.width * 0.15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          widget.order.client.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          dateFormat.format(widget.order.registrationDate),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.order.orderItemList.length,
                          itemBuilder: (context, index) {
                            final item = widget.order.orderItemList[index];
                            return Container(
                              width: size.width,
                              padding: const EdgeInsets.only(top: 1, bottom: 1),
                              decoration: const BoxDecoration(
                                  border:
                                      Border(bottom: BorderSide(width: 0.5))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 1, 2, 1),
                                    child: Text(
                                      item.quantity.toString(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 1, 2, 1),
                                    child: Text(
                                      item.product.category,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        item.product.name,
                                      ),
                                      item.note.isNotEmpty
                                          ? Text(
                                              ' - ${item.note}',
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.7,
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => OrderReportModalBottomMenu(
                    order: widget.order,
                    onGenerateImage: () {
                      TransformWidgetToImage.transformAndLaunch(repaintKey,
                          '${widget.order.client.name} - ${dateFormat.format(widget.order.registrationDate)}');
                    },
                    onGeneratePDF: () {},
                    onGenerateXLSX: () {},
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Compartilhar'.toUpperCase(),
                  ),
                  const Icon(Icons.share)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
