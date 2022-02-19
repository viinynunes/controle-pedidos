import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/product_registration_page.dart';
import 'package:controle_pedidos/utils/show_snack_bar.dart';
import 'package:controle_pedidos/widgets/tiles/order_item_tile.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderRegistrationPage extends StatefulWidget {
  const OrderRegistrationPage({Key? key, this.order}) : super(key: key);

  final OrderData? order;

  @override
  _OrderRegistrationPageState createState() => _OrderRegistrationPageState();
}

class _OrderRegistrationPageState extends State<OrderRegistrationPage> {
  List<ClientData> clientList = [];
  List<ProductData> productList = [];
  bool loading = false;

  List<OrderItemData> orderItemList = [];

  late OrderData newOrder;

  ClientData? client;
  ProductData? _selectedProduct;
  OrderItemData? orderItem;

  final _quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _quantityFocus = FocusNode();
  final _dialogSearchProductFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _setClientList();
    _setProductList();
    _quantityController.text = '1';

    if (widget.order != null) {
      newOrder = OrderData.fromMap(widget.order!.toMap());
      client = newOrder.client;
      _setOrderItemList();
    } else {
      newOrder = OrderData();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showProductListDialog() async {
      return showDialog(
          context: context,
          builder: (context) {
            var filteredProducts = [];
            return AlertDialog(
              title: const Text(
                'Selecione um produto',
                textAlign: TextAlign.center,
              ),
              content: StatefulBuilder(
                builder: (context, a) => SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        focusNode: _dialogSearchProductFocus,
                        onChanged: (e) {
                          if (e.isNotEmpty) {
                            for (var p in productList) {
                              if (p.name
                                  .toLowerCase()
                                  .contains(e.toLowerCase())) {
                                setState(() {
                                  filteredProducts.add(p);
                                });
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(
                          height: 400,
                          width: 400,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              _dialogSearchProductFocus.requestFocus();
                              var product = productList[index];
                              return ListTile(
                                title: Text(product.toString()),
                                onTap: () {
                                  setState(() {
                                    _selectedProduct = product;
                                    Navigator.pop(context);
                                  });
                                },
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    void _showProductRegistrationPage({ProductData? product}) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => product == null
              ? const ProductRegistrationPage()
              : ProductRegistrationPage(
                  product: product,
                ),
        ),
      );
      await _setProductList();
    }

    return ScopedModelDescendant<OrderModel>(
      builder: (context, child, model) => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title:
              Text(widget.order == null ? 'Novo Pedido' : newOrder.client.name),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  _showProductRegistrationPage(product: _selectedProduct);
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () async {
                  if (orderItemList.isNotEmpty) {
                    _setOrder();
                    if (widget.order == null) {
                      ShowSnackBar.showSnackBar(context, 'Salvando Pedido');
                      await model.createOrder(newOrder);
                    } else {
                      ShowSnackBar.showSnackBar(context, 'Salvando Pedido');
                      await model.updateOrder(newOrder);
                    }
                    Navigator.pop(context, newOrder);
                  }
                },
                icon: const Icon(Icons.save)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_selectedProduct != null) {
                _setOrderItem();
                setState(() {
                  orderItemList.add(orderItem!);
                  _clearFields();
                  _quantityFocus.requestFocus();
                });
              }
            }
          },
          child: const Icon(Icons.add),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                loading
                    ? const LinearProgressIndicator()
                    :
                    //Select Client
                    SizedBox(
                        height: 60,
                        child: DropdownSearch<ClientData>(
                          selectedItem: client,
                          showSearchBox: true,
                          items: clientList,
                          dropdownButtonBuilder: (_) =>
                              const SizedBox(child: null),
                          dropdownBuilderSupportsNullItem: true,
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Selecione o cliente',
                            labelStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                          onChanged: (e) {
                            setState(() {
                              client = e!;
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          //Quantity
                          child: TextFormField(
                            focusNode: _quantityFocus,
                            controller: _quantityController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
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
                          child: loading
                              ? const Center(child: LinearProgressIndicator())
                              : SizedBox(
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showProductListDialog();
                                    },
                                    child: Text(
                                      _selectedProduct == null
                                          ? 'Selecione um produto'
                                          : _selectedProduct.toString(),
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                        ),
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
    setState(() {
      loading = true;
    });
    final list = await ProductModel.of(context).getFilteredEnabledProducts();

    setState(() {
      productList = list;
      loading = false;
    });
  }

  Future<void> _setClientList() async {
    setState(() {
      loading = true;
    });
    final list = await ClientModel.of(context).getFilteredClients();

    setState(() {
      clientList = list;
      loading = false;
    });
  }

  void _setOrderItemList() {
    setState(() {
      orderItemList = newOrder.orderItemList!;
    });
  }

  void _setOrderItem() {
    orderItem = OrderItemData(
        quantity: int.parse(_quantityController.text),
        product: _selectedProduct!);
  }

  void _setOrder() {
    newOrder.client = client!;
    newOrder.creationDate = widget.order == null ? DateTime.now() : widget.order!.creationDate;
    newOrder.enabled = true;
    newOrder.orderItemList = orderItemList;
  }

  void _clearFields() {
    _quantityController.text = '1';
    _selectedProduct = null;
  }
}
