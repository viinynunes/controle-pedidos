import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StockListTile extends StatefulWidget {
  const StockListTile(
      {Key? key,
      required this.stock,
      required this.editable,
      required this.onDelete})
      : super(key: key);

  final StockData stock;
  final bool editable;

  final VoidCallback onDelete;

  @override
  _StockListTileState createState() => _StockListTileState();
}

class _StockListTileState extends State<StockListTile> {
  final _stockInputController = TextEditingController();
  final _stockFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  late int totalOrdered;

  @override
  void initState() {
    super.initState();

    int left = widget.stock.totalOrdered - widget.stock.total;
    _stockInputController.text = left.toString();
  }

  @override
  Widget build(BuildContext context) {
    StockData stock = widget.stock;

    void _updateStockTotal() {
      stock.totalOrdered = int.parse(_stockInputController.text) + stock.total;
      StockModel.of(context).updateStockItem(
        stock,
        () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro adicionar sobra'),
            backgroundColor: Colors.red,
          ),
        ),
      );
      setState(
        () {
          totalOrdered = stock.total + int.parse(_stockInputController.text);
        },
      );
    }

    return Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: null,
          children: [
            SlidableAction(
              onPressed: (e) {
                widget.onDelete();
              },
              icon: Icons.delete_forever,
              backgroundColor: Colors.red,
              label: 'Apagar',
            ),
          ],
        ),
        child: InkWell(
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 1, right: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Product Name
                    Flexible(
                      flex: 3,
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
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        stock.totalOrdered.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //Stock
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: TextFormField(
                        enabled: widget.editable ? true : false,
                        textAlign: TextAlign.center,
                        focusNode: _stockFocus,
                        autofocus: true,
                        controller: _stockInputController,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple))),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (e) {
                          if (_formKey.currentState!.validate()) {
                            _updateStockTotal();
                            _stockInputController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    _stockInputController.value.text.length);
                          }
                        },
                        validator: (e) {
                          var regExp =
                              RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                  .hasMatch(e!);
                          if (_stockInputController.text.isEmpty || !regExp) {
                            return '';
                          }
                          return null;
                        },
                        enableInteractiveSelection: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
