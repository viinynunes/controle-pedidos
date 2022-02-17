import 'package:controle_pedidos/data/stock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StockListTile extends StatefulWidget {
  const StockListTile({Key? key, required this.stock}) : super(key: key);

  final StockData stock;

  @override
  _StockListTileState createState() => _StockListTileState();
}

class _StockListTileState extends State<StockListTile> {
  final _stockInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late int totalOrdered;

  @override
  void initState() {
    super.initState();

    totalOrdered = widget.stock.total + widget.stock.left;
    _stockInputController.text = widget.stock.left.toString();
  }

  @override
  Widget build(BuildContext context) {
    StockData stock = widget.stock;

    void _updateData() {
      setState(() {
        totalOrdered = stock.total + int.parse(_stockInputController.text);
      });
    }

    return Slidable(
        child: InkWell(
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Product Name
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Text(stock.product.name),
            ),
            //Total From Order
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Text(
                stock.total.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            //Total Including stock
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                totalOrdered.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            //Stock
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: SizedBox(
                height: 30,
                child: TextFormField(

                  textAlign: TextAlign.center,
                  controller: _stockInputController,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple))),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (e) {
                    if (_formKey.currentState!.validate()) {
                      _updateData();
                    }
                  },
                  validator: (e) {
                    var regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                        .hasMatch(e!);
                    if (_stockInputController.text.isEmpty || !regExp) {
                      return 'Quantidade Inválida';
                    }
                  },
                  enableInteractiveSelection: false,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
