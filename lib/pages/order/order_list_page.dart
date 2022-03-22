import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/pages/order/order_registration_page.dart';
import 'package:controle_pedidos/services/order_services.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final dateFormat = DateFormat('dd-MM-yyyy');
  List<OrderData> orderList = [];

  final orderService = OrderServices();

  late DateTime _selectedDate;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    orderList = OrderModel.of(context).orderListAll;
    if (orderList.isEmpty){
      _setOrderList();
    }
    _selectedDate = OrderModel.of(context).orderDate;
  }

  @override
  Widget build(BuildContext context) {
    void _showOrderRegistrationPage({OrderData? order}) async {
      final recOrder = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => order == null
                  ? const OrderRegistrationPage()
                  : OrderRegistrationPage(
                      order: order,
                    )));
      if (recOrder != null) {
        if (order == null) {
          OrderModel.of(context).createOrder(recOrder);
          setState(() {
            orderList.add(recOrder);
          });
        } else {
          await OrderModel.of(context).updateOrder(recOrder);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _setOrderList();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: CustomColors.backgroundColor,
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
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
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2050))
                            .then((value) {
                          setState(() {
                            if (value != null) {
                              _selectedDate = value;
                              _setOrderList();
                            }
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Text(dateFormat.format(_selectedDate)),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      )),
                ],
              ),
              loading
                  ? const CircularProgressIndicator()
                  :
                  //List of Orders
                  Expanded(
                      child: ListView.builder(
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          var order = orderList[index];
                          return Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              dismissible: null,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (e) {
                                    model.disableOrder(order);
                                    orderList.remove(order);
                                  },
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
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _setOrderList() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
      final list =
          await OrderModel.of(context).getEnabledOrderFromDate(_selectedDate);
      setState(() {
        orderList.clear();
        orderList = list;
        orderService.sortByDate(orderList);
        loading = false;
      });
    }
  }
}
