import 'package:flutter/material.dart';

import '../../../../../../domain/entities/stock.dart';
import '../widgets/divide_stock_between_providers_dialog.dart';

class ModalBottomSheetStockTile extends StatelessWidget {
  const ModalBottomSheetStockTile({
    Key? key,
    required this.stock,
    required this.onDelete,
    required this.onChangeDate,
    required this.equalDates,
  }) : super(key: key);

  final Stock stock;
  final bool equalDates;
  final VoidCallback onDelete;
  final Function(DateTime selectedDate) onChangeDate;

  @override
  Widget build(BuildContext context) {
    _getListItem({
      required VoidCallback onTap,
      required IconData icon,
      required String titleText,
      required String subtitleText,
      required bool enabled,
      Color? textColor,
      Color? iconColor,
    }) {
      return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: ListTile(
          onTap: onTap,
          enabled: enabled,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
            ],
          ),
          textColor: textColor,
          title: Text(titleText),
          subtitle: Text(subtitleText),
        ),
      );
    }

    return Column(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                stock.product.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
        _getListItem(
            onTap: () async {
              Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (_) => DivideStockBetweenProvidersDialog(
                  stock: stock,
                ),
              );
            },
            enabled: equalDates,
            icon: Icons.safety_divider,
            titleText: 'Dividir Entre Fornecedores',
            subtitleText: 'Divide o item entre 2 ou mais fornecedores'),
        _getListItem(
            enabled: equalDates,
            onTap: () async {
              await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2200))
                  .then((value) {
                if (value != null) {
                  onChangeDate(value);
                }
              });

              Navigator.of(context).pop();
            },
            icon: Icons.date_range,
            titleText: 'Alterar Data',
            subtitleText: 'Move o item e suas propriedades para outra data'),
        _getListItem(
            enabled: true,
            onTap: () {},
            icon: Icons.list_rounded,
            titleText: 'Ver Pedidos',
            subtitleText:
                'Exibe a lista de pedidos onde o item foi adicionado'),
        _getListItem(
            enabled: equalDates,
            onTap: () {
              onDelete();
              Navigator.of(context).pop();
            },
            icon: Icons.delete_forever_outlined,
            titleText: 'Apagar Item',
            subtitleText: 'Apaga o item da base de dados',
            textColor: Theme.of(context).errorColor,
            iconColor: Theme.of(context).errorColor),
      ],
    );
  }
}
