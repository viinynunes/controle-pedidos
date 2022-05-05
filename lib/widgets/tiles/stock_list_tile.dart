import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:universal_html/html.dart' as html;

class StockListTile extends StatefulWidget {
  const StockListTile({
    Key? key,
    required this.stock,
    required this.editable,
    required this.index,
    required this.length,
    required this.selected,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  final StockData stock;
  final bool editable;
  final bool selected;
  final int index;
  final int length;

  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  _StockListTileState createState() => _StockListTileState();
}

class _StockListTileState extends State<StockListTile> {
  final _stockInputController = TextEditingController();
  final _stockFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _stockInputController.text = widget.stock.totalOrdered.toString();
  }

  @override
  Widget build(BuildContext context) {
    StockData stock = widget.stock;

    void _updateStockTotal() {
      setState(
        () {
          stock.totalOrdered = int.parse(_stockInputController.text);
        },
      );

      StockModel.of(context).updateStockItem(
        stock,
        () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro adicionar sobra'),
            backgroundColor: Colors.red,
          ),
        ),
      );

      _stockFocus.nextFocus();
      if (widget.index == widget.length) {
        FocusScope.of(context).unfocus();
      }
    }

    Future<void> _onPointerDown(PointerDownEvent event) async {
      if (kIsWeb) {
        html.document.body!
            .addEventListener('contextmenu', (event) => event.preventDefault());

        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          final overlay =
              Overlay.of(context)?.context.findRenderObject() as RenderBox;
          final menuItem = await showMenu<int>(
              context: context,
              items: [
                const PopupMenuItem(child: Text('Editar'), value: 1),
                const PopupMenuItem(child: Text('Apagar'), value: 2),
              ],
              position: RelativeRect.fromSize(
                  event.position & const Size(48.0, 48.0), overlay.size));

          switch (menuItem) {
            case 1:
              widget.onEdit();
              break;
            case 2:
              widget.onDelete();
              break;
          }
        }
      }
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
            SlidableAction(
              onPressed: (e) {
                widget.onEdit();
              },
              icon: Icons.edit,
              backgroundColor: Colors.blueAccent,
              label: 'Editar',
            ),
          ],
        ),
        child: Listener(
          onPointerDown: _onPointerDown,
          child: InkWell(
            highlightColor: Colors.deepPurple,
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.selected
                      ? Colors.deepPurple.withOpacity(0.8)
                      : CustomColors.backgroundTile,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Product Name
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Text(
                          stock.product.name,
                          style: _textStyle(),
                        ),
                      ),
                      //Total From Order
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          stock.total.toString(),
                          textAlign: TextAlign.center,
                          style: _textStyle(),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: TextFormField(
                          enabled: widget.editable ? true : false,
                          textAlign: TextAlign.center,
                          focusNode: _stockFocus,
                          autofocus: true,
                          controller: _stockInputController,
                          style: const TextStyle(
                              fontSize: 15, color: CustomColors.textColorTile),
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
                      //Total Including stock
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          (widget.stock.totalOrdered - widget.stock.total)
                              .toString(),
                          textAlign: TextAlign.center,
                          style: _textStyle(),
                        ),
                      ),
                      //Stock
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  TextStyle _textStyle() {
    return const TextStyle(color: CustomColors.textColorTile);
  }
}
