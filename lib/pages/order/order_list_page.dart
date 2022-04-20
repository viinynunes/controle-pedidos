import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/order_item_model.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/model/product_model.dart';
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

  final orderService = OrderServices();
  List<OrderData> orderList = [];

  late DateTime _selectedDate;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = OrderModel.of(context).orderDate;
    _setOrderList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void _showOrderRegistrationPage({OrderData? order}) async {

      if (order != null){
        setState(() {
          loading = true;
        });
        await OrderItemModel.of(context).getOrderItemFromOrder(order);
        setState(() {
          loading = false;
        });
      }

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
          OrderModel.of(context).createOrder(recOrder, () {
            _showSnackBar('Pedido cadastrado', Colors.green);
          }, () {
            _showSnackBar('Erro ao cadastrar pedido', Colors.red);
          });
          setState(() {
           orderList.add(recOrder);
          });
        } else {
          await OrderModel.of(context).updateOrder(recOrder);
        }
        setState(() {
          orderService.sortByDate(orderList);
        });
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
              await ProductModel.of(context).getFilteredEnabledProducts();
              await ClientModel.of(context).getFilteredClients();
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
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
                  ),
                ],
              ),
              loading
                  ? const Padding(
                      padding: EdgeInsets.all(35),
                      child: Center(child: CircularProgressIndicator()))
                  :
                  //List of Orders
                  Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 15),
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          var order =
                              orderList[index];
                          return Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              dismissible: null,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (e) {
                                    model.disableOrder(order);
                                    orderList
                                        .remove(order);
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
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: size.width > 600
                                      ? 1080
                                      : double.maxFinite,
                                ),
                                child: OrderListTile(
                                  order: order,
                                  showOrderRegistrationPage: () {
                                    _showOrderRegistrationPage(order: order);
                                  },
                                ),
                              ),
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
        orderList = list;
        OrderModel.of(context).orderListAll.clear();
        OrderModel.of(context).orderListAll = list;
        orderService.sortByDate(orderList);
        loading = false;
      });
    }
  }

  _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        backgroundColor: CustomColors.backgroundTile,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 18),
        ),
      ),
    );
  }
}
