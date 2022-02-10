import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/order_list_tile.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: orderList?.length,
        itemBuilder: (context, index) {
          var order = orderList?[index];
          if (order != null) {
            return OrderListTile(
              order: order,
            );
          }
          return Container();
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
