import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../store/stock_controller.dart';
import 'provider_dropdown_selection_widget.dart';
import 'stock_left_textfield_widget.dart';

class ProviderSelectionAndStockLeftWidget extends StatelessWidget {
  const ProviderSelectionAndStockLeftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<StockController>();

    return Observer(
      builder: (_) => controller.loading
          ? const Center(
              heightFactor: 10,
              child: LinearProgressIndicator(),
            )
          : controller.providerList.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: ProviderDropdownSelectionWidget(),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: StockLeftTextFieldWidget(),
                    ),
                  ],
                )
              : Container(),
    );
  }
}
