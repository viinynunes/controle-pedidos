import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/helpers.dart';
import '../../../store/stock_controller.dart';

class StockLeftTextFieldWidget extends StatefulWidget {
  const StockLeftTextFieldWidget({Key? key}) : super(key: key);

  @override
  State<StockLeftTextFieldWidget> createState() =>
      _StockLeftTextFieldWidgetState();
}

class _StockLeftTextFieldWidgetState extends State<StockLeftTextFieldWidget> {
  final controller = GetIt.I.get<StockController>();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: Helpers.compareOnlyDateFromDateTime(
          controller.iniDate, controller.endDate),
      controller: controller.stockDefaultLeftController,
      decoration: const InputDecoration(
        labelText: 'Sobra',
      ),
      textAlign: TextAlign.center,
      onTap: () {
        controller.stockDefaultLeftController.selection = TextSelection(
            baseOffset: 0,
            extentOffset:
                controller.stockDefaultLeftController.value.text.length);
      },
      onFieldSubmitted: controller.stockLeftSubmit,
      keyboardType: TextInputType.phone,
    );
  }
}
