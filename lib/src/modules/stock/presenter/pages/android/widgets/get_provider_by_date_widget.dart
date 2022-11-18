import 'package:controle_pedidos/src/modules/stock/presenter/store/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class GetProviderByDateWidget extends StatelessWidget {
  const GetProviderByDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<StockController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Observer(
            builder: (_) => ElevatedButton(
              onPressed: () => controller.showDateTimeRangeSelector(context),
              child: Text(
                controller.selectedDateString,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: controller.getProviderListByStockBetweenDates,
            child: const Text('Buscar Fornecedores', textAlign: TextAlign.center,),
          ),
        ),
      ],
    );
  }
}
