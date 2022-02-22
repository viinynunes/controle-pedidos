import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/utils/transform_widget_to_image.dart';
import 'package:controle_pedidos/utils/widget_to_image.dart';
import 'package:flutter/material.dart';

class ShareStockItemsByProvider extends StatefulWidget {
  const ShareStockItemsByProvider(
      {Key? key, required this.providerName, required this.stockList})
      : super(key: key);

  final String providerName;
  final List<StockData> stockList;

  @override
  _ShareStockItemsByProviderState createState() =>
      _ShareStockItemsByProviderState();
}

class _ShareStockItemsByProviderState extends State<ShareStockItemsByProvider> {
  late GlobalKey key1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.providerName),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            await TransformWidgetToImage.getWidget(key1, widget.providerName);
          }, icon: const Icon(Icons.share)),
        ],
      ),
      body: WidgetToImage(
        builder: (key) {
          key1 = key;
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    widget.providerName,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: widget.stockList.length,
                    itemBuilder: (context, index) {
                      var item = widget.stockList[index];
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(item.totalOrdered.toString() +
                                ' ' +
                                item.product.category +
                                ' ' +
                                item.product.name),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
