import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/pages/order/order_registration_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<OrderData>? orderList = [];

  @override
  void initState() {
    super.initState();
    _setOrderList();
  }

  @override
  Widget build(BuildContext context) {
    void _showOrderRegistrationPage({OrderData? order}) async {
      final recOrder = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => order == null
                  ? OrderRegistrationPage()
                  : OrderRegistrationPage(
                      order: order,
                    )));
      if (recOrder != null) {
        _setOrderList();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOrderRegistrationPage();
        },
        child: const Icon(Icons.add),
      ),
      body: ScopedModelDescendant<OrderModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder(
            future: _setOrderList(),
            builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: orderList?.length,
                  itemBuilder: (context, index) {
                    var order = orderList?[index];
                    if (order != null) {
                      return Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          dismissible: null,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (e) {},
                              icon: Icons.delete_forever,
                              backgroundColor: Colors.red,
                              label: 'Apagar',
                            ),
                            SlidableAction(
                              onPressed: (e) {
                                _showOrderRegistrationPage(order: order);
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.deepPurple,
                              label: 'Editar',
                            ),
                          ],
                        ),
                        child: OrderListTile(
                          order: order,
                          showOrderRegistrationPage: () {
                            _showOrderRegistrationPage(order: order);
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                );
              }
          );
        },
      ),
    );
  }

  Future<void> _setOrderList() async {
    final list = await OrderModel.of(context).getAllEnabledOrders();
    setState(() {
      orderList = list;
    });
  }
}
