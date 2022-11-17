import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/widgets/shimmer/shimmer_list_builder.dart';
import '../../../store/stock_controller.dart';
import 'provider_dropdown_selection_widget.dart';
import 'stock_left_textfield_widget.dart';

class ProviderSelectionAndStockLeftWidget extends StatelessWidget {
  const ProviderSelectionAndStockLeftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<StockController>();

    final size = MediaQuery.of(context).size;

    return Observer(
      builder: (_) => controller.loading
          ? SizedBox(
              height: size.height * 0.1,
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: ShimmerListBuilder(
                        height: size.height * 0.07,
                        width: double.maxFinite,
                        itemCount: 1),
                  ),
                  Flexible(
                    flex: 1,
                    child: ShimmerListBuilder(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: double.maxFinite,
                        itemCount: 1),
                  ),
                ],
              ),
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
