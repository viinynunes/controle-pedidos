import 'package:controle_pedidos/src/modules/order/presenter/pages/android/android_order_registration_page.dart';
import 'package:controle_pedidos/src/modules/order/presenter/stores/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'tiles/android_order_list_tile.dart';

class AndroidOrderListPage extends StatefulWidget {
  const AndroidOrderListPage({Key? key}) : super(key: key);

  @override
  State<AndroidOrderListPage> createState() => _AndroidOrderListPageState();
}

class _AndroidOrderListPageState extends State<AndroidOrderListPage> {
  final controller = GetIt.I.get<OrderController>();

  @override
  void initState() {
    super.initState();

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
            builder: (_) => controller.searching
                ? TextField(
                    focusNode: controller.searchFocus,
                    decoration:
                        const InputDecoration(hintText: 'Pesquisar Pedido'),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (text) {
                      controller.searchText = text;
                      controller.filterOrderListByText();
                    },
                    keyboardType: TextInputType.url,
                  )
                : const Text('Pedidos')),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => controller.searching
                ? IconButton(
                    onPressed: () {
                      controller.searching = false;
                      controller.searchText = '';
                      controller.getOrderListBetweenDates();
                    },
                    icon: const Icon(Icons.clear),
                  )
                : IconButton(
                    onPressed: () {
                      controller.searching = true;
                      controller.searchFocus.requestFocus();
                    },
                    icon: const Icon(Icons.search),
                  ),
          ),
          IconButton(
              onPressed: controller.initState, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.callOrderRegistrationPage(
          context: context,
          registrationPage: AndroidOrderRegistrationPage(
            productList: controller.productList,
            clientList: controller.clientList,
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Observer(
                    builder: (_) => controller.loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              await showDateRangePicker(
                                context: context,
                                initialDateRange: DateTimeRange(
                                  start: controller.iniDate,
                                  end: controller.endDate,
                                ),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2050),
                              ).then((result) {
                                if (result != null) {
                                  controller.changeDateRangeSelected(
                                      result.start, result.end);
                                }
                              });
                            },
                            child: Text(controller.dateRangeSelected),
                          ),
                  ),
                ),
                Expanded(
                  child: Observer(builder: (_) {
                    var orderList = [];

                    if (controller.searching &&
                        controller.searchText.isNotEmpty) {
                      orderList = controller.filteredOrderList;
                    } else {
                      orderList = controller.orderList;
                    }

                    if (controller.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return orderList.isNotEmpty
                        ? ListView.builder(
                            itemCount: orderList.length,
                            itemBuilder: (_, index) {
                              final order = orderList[index];

                              return AndroidOrderListTile(
                                order: order,
                                onTap: () =>
                                    controller.callOrderRegistrationPage(
                                  context: context,
                                  registrationPage:
                                      AndroidOrderRegistrationPage(
                                    productList: controller.productList,
                                    clientList: controller.clientList,
                                    order: order,
                                  ),
                                ),
                                onDisable: () => controller.disableOrder(order),
                              );
                            },
                          )
                        : const Center(
                            child: Text('Nenhum pedido encontrado'),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
