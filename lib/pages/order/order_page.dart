import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/order_item_tile.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key, this.client}) : super(key: key);

  ClientData? client;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<ClientData> clientList = [];
  List<ProductData> productList = [];

  List<OrderItemData> orderItemList = [];

  late OrderData order;

  ProductData? _selectedProduct;
  OrderItemData? orderItem;

  final _quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _quantityFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _setClientList();
    _setProductList();
    _quantityController.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OrderModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: const Text('Pedido'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (orderItemList.isNotEmpty) {
                    _setOrder();
                    model.createOrder(order);
                  }
                },
                icon: const Icon(Icons.save))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _setOrderItem();
              setState(() {
                orderItemList.add(orderItem!);
                _clearFields();
                _quantityFocus.requestFocus();
              });
            }
          },
          child: const Icon(Icons.add),
        ),
        drawer: const CustomDrawer(),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                //Select Client
                SizedBox(
                  height: 60,
                  child: DropdownSearch<ClientData>(
                    selectedItem: widget.client,
                    showSearchBox: true,
                    items: clientList,
                    dropdownSearchDecoration: const InputDecoration(
                      label: Text('Selecione o Cliente'),
                    ),
                    onChanged: (e) {
                      setState(() {
                        widget.client = e;
                      });
                    },
                    validator: (e) {
                      if (e == null) {
                        return 'Selecione o cliente';
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //Line with quantity and product
                SizedBox(
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 65,
                          width: 80,
                          child: TextFormField(
                            focusNode: _quantityFocus,
                            controller: _quantityController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'Quantidade',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (e) {
                              var regExp =
                                  RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                      .hasMatch(e!);
                              if (_quantityController.text.isEmpty || !regExp) {
                                return 'Quantidade Inválida';
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //Product
                        Expanded(
                          child: DropdownSearch<ProductData>(
                            items: productList,
                            selectedItem: _selectedProduct,
                            showSearchBox: true,
                            dropdownSearchDecoration: InputDecoration(
                              label: const Text('Selecione o produto'),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                            ),
                            onChanged: (e) {
                              setState(() {
                                _selectedProduct = e;
                              });
                            },
                            validator: (e) {
                              if (e == null) {
                                return 'Selecione um produto';
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //Line with a ListView that contains the order items
                Expanded(
                  child: ListView.builder(
                    itemCount: orderItemList.length,
                    itemBuilder: (context, index) {
                      var orderItem = orderItemList[index];
                      return Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          dismissible: null,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (e) {
                                setState(() {
                                  orderItemList.remove(orderItem);
                                });
                              },
                              icon: Icons.delete_forever,
                              backgroundColor: Colors.red,
                            ),
                            SlidableAction(
                              onPressed: (e) {},
                              icon: Icons.edit,
                              backgroundColor: Colors.deepPurple,
                            ),
                          ],
                        ),
                        child: OrderItemTile(
                          orderItem: orderItem,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setProductList() async {
    final list = await ProductModel.of(context).getFilteredEnabledProducts();

    setState(() {
      productList = list;
    });
  }

  Future<void> _setClientList() async {
    final list = await ClientModel.of(context).getFilteredClients();

    setState(() {
      clientList = list;
    });
  }

  void _setOrderItem() {
    orderItem = OrderItemData(
        quantity: int.parse(_quantityController.text),
        product: _selectedProduct!);
  }

  void _setOrder(){
    order = OrderData(client: widget.client!, creationDate: DateTime.now(), enabled: true);
  }

  void _clearFields() {
    _quantityController.text = '1';
    _selectedProduct = null;
  }
}
