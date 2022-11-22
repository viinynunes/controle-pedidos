import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../domain/entities/provider.dart';
import '../../../store/stock_controller.dart';

class ProviderDropdownSelectionWidget extends StatelessWidget {
  const ProviderDropdownSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<StockController>();

    return DropdownButtonFormField<Provider>(
      value: controller.selectedProvider,
      alignment: Alignment.center,
      items: controller.getProviderDropdownItems(context),
      decoration: InputDecoration(
          labelText: 'Fornecedores',
          labelStyle: Theme.of(context).textTheme.titleSmall),
      onChanged: (provider) {
        if (provider != null) {
          controller.setSelectedProvider(provider);
          controller.getStockListByProviderBetweenDates();
          controller.resetStockLeft();
        }
      },
    );
  }
}
