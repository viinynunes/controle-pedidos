import 'package:controle_pedidos/src/modules/order/presenter/pages/android/android_order_registration_page.dart';
import 'package:controle_pedidos/src/modules/order/presenter/stores/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/drawer/widgets/android_custom_drawer.dart';

class AndroidOrderListPage extends StatefulWidget {
  const AndroidOrderListPage({Key? key}) : super(key: key);

  @override
  State<AndroidOrderListPage> createState() => _AndroidOrderListPageState();
}

class _AndroidOrderListPageState extends State<AndroidOrderListPage> {
  final controller = GetIt.I.get<OrderController>();

  final dateFormat = DateFormat('dd-MM-yyyy');

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
                      controller.getOrderListByDate();
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
                              final date = await showDatePicker(
                                  context: context,
                                  initialDate: controller.selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2200));

                              if (date != null) {
                                controller.changeSelectedDate(date);
                              }
                            },
                            child: Text(
                              dateFormat.format(controller.selectedDate),
                            ),
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

                              return ListTile(
                                title: Text(order.toString()),
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
