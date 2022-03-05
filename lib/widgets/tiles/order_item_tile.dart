import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({Key? key, required this.orderItem}) : super(key: key);

  final OrderItemData orderItem;

  @override
  Widget build(BuildContext context) {
    var _rectKey = RectGetter.createGlobalKey();

    _showPopUpMenu(Rect rect) async {
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(rect.left + 5, rect.top + 40, rect.right, rect.bottom),
        items: [
          const PopupMenuItem(
            child: SizedBox(
              width: 500,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Observação',
                  labelStyle: TextStyle(color: CustomColors.textColorTile),
                ),
                style: TextStyle(color: CustomColors.textColorTile),
              ),
            ),
          ),
        ],
        elevation: 8,
        color: CustomColors.backgroundTile
      );
    }

    return RectGetter(
      key: _rectKey,
      child: InkWell(
        onLongPress: (){
          var rect = RectGetter.getRectFromKey(_rectKey);
          _showPopUpMenu(rect!);
        },
        child: Card(
          color: CustomColors.backgroundTile,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Text(
                      orderItem.product.name,
                      style: const TextStyle(color: CustomColors.textColorTile),
                    )),
                Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Text(
                      orderItem.product.category,
                      style: const TextStyle(color: CustomColors.textColorTile),
                    )),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      orderItem.product.provider.name,
                      style: const TextStyle(color: CustomColors.textColorTile),
                    )),
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(
                      orderItem.quantity.toString(),
                      style: const TextStyle(color: CustomColors.textColorTile),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
