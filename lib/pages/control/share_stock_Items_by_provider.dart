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

    final desktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.providerName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await TransformWidgetToImage.getWidget(
                    key1, widget.providerName);
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: WidgetToImage(
        builder: (key) {
          key1 = key;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: desktop ? 720 : double.maxFinite
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.providerName,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: ListView.builder(
                          itemCount: widget.stockList.length,
                          itemBuilder: (context, index) {
                            var item = widget.stockList[index];
                            return Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 0.5))),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        item.product.name + ' ',
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        item.totalOrdered.toString() +
                                            '        ' +
                                            item.product.category,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
