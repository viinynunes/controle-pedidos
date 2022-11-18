import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/widgets/shimmer/shimmer_list_builder.dart';
import '../../../store/stock_controller.dart';
import '../tiles/android_stock_tile.dart';

class StockListBuilderWidget extends StatelessWidget {
  const StockListBuilderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<StockController>();

    return Observer(
      builder: (_) {
        if (controller.loading && controller.selectedProvider != null) {
          return Expanded(
            child: ShimmerListBuilder(
                height: MediaQuery.of(context).size.height * 0.03,
                width: double.maxFinite,
                itemCount: 50),
          );
        }

        return Expanded(
          child: controller.stockList.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.stockList.length,
                  itemBuilder: (_, index) {
                    final stock = controller.stockList[index];
                    return AndroidStockTile(
                        key: ObjectKey(stock), stock: stock);
                  },
                )
              : const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('Nenhum Item Encontrado'),
                  ),
                ),
        );
      },
    );
  }
}
