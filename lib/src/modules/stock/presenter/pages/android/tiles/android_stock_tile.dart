import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:flutter/material.dart';

class AndroidStockTile extends StatefulWidget {
  const AndroidStockTile({Key? key, required this.stock}) : super(key: key);

  final Stock stock;

  @override
  State<AndroidStockTile> createState() => _AndroidStockTileState();
}

class _AndroidStockTileState extends State<AndroidStockTile> {
  final stockTotalOrderedController = TextEditingController();

  int stockLeft = 0;

  @override
  void initState() {
    super.initState();

    stockTotalOrderedController.text = widget.stock.totalOrdered.toString();
    stockLeft =
        int.parse((widget.stock.totalOrdered - widget.stock.total).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          _getFlexible(flex: 8, text: widget.stock.product.name),
          _getFlexible(flex: 2, text: widget.stock.product.category),
          _getFlexible(flex: 4, text: widget.stock.total.toString()),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: TextField(
              controller: stockTotalOrderedController,
              textAlign: TextAlign.center,
            ),
          ),
          _getFlexible(flex: 4, text: stockLeft.toString()),
        ],
      ),
    );
  }

  _getFlexible({required int flex, required String text}) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
