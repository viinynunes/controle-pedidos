import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/admob/admob_helper.dart';
import '../../../../../../domain/entities/provider.dart';
import '../../../store/stock_controller.dart';

class ProviderDropdownSelectionWidget extends StatefulWidget {
  const ProviderDropdownSelectionWidget({Key? key}) : super(key: key);

  @override
  State<ProviderDropdownSelectionWidget> createState() =>
      _ProviderDropdownSelectionWidgetState();
}

class _ProviderDropdownSelectionWidgetState
    extends State<ProviderDropdownSelectionWidget> {
  final controller = GetIt.I.get<StockController>();
  final adHelper = AdMobHelper();

  @override
  void initState() {
    super.initState();

    adHelper.createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Provider>(
      value: controller.selectedProvider,
      alignment: Alignment.center,
      items: controller.getProviderDropdownItems(context),
      decoration: InputDecoration(
          labelText: 'Fornecedores',
          labelStyle: Theme.of(context).textTheme.bodyMedium),
      onChanged: (provider) async {
        if (provider != null) {
          controller.setSelectedProvider(provider);
          controller.getStockListByProviderBetweenDates();
          controller.resetStockLeft();

          if (controller.loadAd()) {
            //await Future.delayed(const Duration(seconds: 2));
            adHelper.showRewardedAd();
          }
        }
      },
    );
  }
}
