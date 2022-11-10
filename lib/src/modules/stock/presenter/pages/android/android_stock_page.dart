import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../domain/entities/provider.dart';
import '../../../../core/drawer/widgets/android_custom_drawer.dart';
import '../../store/stock_controller.dart';
import '../i_stock_page.dart';
import 'tiles/android_stock_tile.dart';

class AndroidStockPage extends IStockPage {
  const AndroidStockPage({Key? key}) : super(key: key);

  @override
  _AndroidStockPageState createState() => _AndroidStockPageState();
}

class _AndroidStockPageState extends IStockPageState {
  final controller = GetIt.I.get<StockController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AndroidCustomDrawer(),
      appBar: AppBar(
        title: const Text('Estoque'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Observer(
                      builder: (_) => ElevatedButton(
                        onPressed: () =>
                            controller.showDateTimeRangeSelector(context),
                        child: Text(controller.selectedDateString, textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: ElevatedButton(
                      onPressed: controller.getProviderListByStockBetweenDates,
                      child: const Text('Buscar Fornecedores'),
                    ),
                  ),
                ],
              ),
              Observer(
                builder: (_) => controller.providerList.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: DropdownButtonFormField<Provider>(
                              value: controller.selectedProvider,
                              alignment: Alignment.center,
                              items:
                                  controller.getProviderDropdownItems(context),
                              decoration: InputDecoration(
                                  labelText: 'Fornecedores',
                                  labelStyle:
                                      Theme.of(context).textTheme.titleSmall),
                              onChanged: (provider) {
                                if (provider != null) {
                                  controller.setSelectedProvider(provider);

                                  controller
                                      .getStockListByProviderBetweenDates();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: TextFormField(
                              controller: controller.stockDefaultLeftController,
                              decoration: const InputDecoration(
                                labelText: 'Sobra',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              Observer(
                  builder: (_) => controller.stockList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              _getStockTableHeader(flex: 8, text: 'Produto'),
                              _getStockTableHeader(flex: 2, text: 'Emb'),
                              _getStockTableHeader(flex: 4, text: 'Pedido'),
                              _getStockTableHeader(flex: 5, text: 'Total'),
                              _getStockTableHeader(flex: 5, text: 'Sobra'),
                            ],
                          ),
                        )
                      : Container()),
              Observer(
                builder: (_) => Expanded(
                  child: controller.stockList.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.stockList.length,
                          itemBuilder: (_, index) {
                            final stock = controller.stockList[index];
                            return AndroidStockTile(
                              stock: stock,
                            );
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text('Nenhum Item Encontrado'),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getStockTableHeader({required int flex, required String text}) {
    return Flexible(
        flex: flex,
        fit: FlexFit.tight,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ));
  }
}
