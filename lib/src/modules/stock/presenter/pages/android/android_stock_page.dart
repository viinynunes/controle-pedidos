import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../../domain/entities/provider.dart';
import '../../../../core/drawer/widgets/android_custom_drawer.dart';
import '../../store/stock_controller.dart';
import '../i_stock_page.dart';

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
                  Observer(
                    builder: (_) => ElevatedButton(
                      onPressed: () =>
                          controller.showDateTimeRangeSelector(context),
                      child: Text(controller.selectedDateString),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.getProviderListByStockBetweenDates,
                    child: const Text('Buscar Fornecedores'),
                  ),
                ],
              ),
              Observer(
                builder: (_) => controller.providerList.isEmpty
                    ? const Center(
                        child: Text('Nenhum fornecedor encontrado'),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: DropdownButtonFormField<Provider>(
                              value: controller.selectedProvider,
                              items:
                                  controller.getProviderDropdownItems(context),
                              decoration: InputDecoration(
                                  labelText: 'Fornecedores',
                                  labelStyle:
                                      Theme.of(context).textTheme.titleSmall),
                              onChanged: (provider) {
                                if (provider != null) {
                                  controller.setSelectedProvider(provider);
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
                      ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 3,
              //     itemBuilder: (_, index) {
              //       return const ListTile(
              //         title: Text('AAAA'),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
