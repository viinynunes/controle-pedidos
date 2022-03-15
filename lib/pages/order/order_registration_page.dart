import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/order_item_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/showProductListDialog.dart';
import 'package:controle_pedidos/services/client_service.dart';
import 'package:controle_pedidos/services/product_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/utils/enum_order_registration_page.dart';
import 'package:controle_pedidos/widgets/tiles/order_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../client/show_client_list_dialog.dart';

class OrderRegistrationPage extends StatefulWidget {
  const OrderRegistrationPage({Key? key, this.order}) : super(key: key);

  final OrderData? order;

  @override
  _OrderRegistrationPageState createState() => _OrderRegistrationPageState();
}

class _OrderRegistrationPageState extends State<OrderRegistrationPage> {
  final productService = ProductService();
  final clientService = ClientService();

  List<ClientData> clientList = [];
  List<ProductData> productList = [];
  bool loading = false;

  List<OrderItemData> orderItemList = [];

  late OrderData newOrder;

  ClientData? client;
  ProductData? _selectedProduct;
  OrderItemData? orderItem;
  String? note;

  final _quantityController = TextEditingController();
  final _rectKey = RectGetter.createGlobalKey();
  final _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _quantityFocus = FocusNode();
  final _selectProductFocus = FocusNode();

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
    _quantityFocus.requestFocus();
  }

  _showPopUpMenu(Rect rect) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          rect.left + 5, rect.top + 40, rect.right, rect.bottom),
      items: [
        PopupMenuItem(
          child: SizedBox(
            width: 500,
            child: TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Observação',
                labelStyle: TextStyle(color: CustomColors.textColorTile),
              ),
              style: const TextStyle(color: CustomColors.textColorTile),
              onSubmitted: (value) {
                if (_noteController.text.isNotEmpty) {
                  setState(() {
                    note = _noteController.text;
                  });
                }
                _noteController.text = '';
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
      elevation: 8,
      color: CustomColors.backgroundTile,
    );
  }

  @override
  Widget build(BuildContext context) {
    void _showProductRegistrationPage({ProductData? product}) async {
      var recProduct = await productService.createOrUpdate(
          product: product, productList: productList, context: context);

      if (recProduct != null) {
        _selectedProduct = recProduct;
      }

      setState(() {
        productService.sortProductsByName(productList);
      });

      await _setProductList();
    }

    return ScopedModelDescendant<OrderModel>(
      builder: (context, child, model) => Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        appBar: AppBar(
          title:
              Text(widget.order == null ? 'Novo Pedido' : newOrder.client.name),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                if (orderItemList.isNotEmpty) {
                  if (client == null) {
                    _showSnackBarError('Selecione o cliente');
                  } else {
                    _setOrder();
                    Navigator.pop(context, newOrder);
                  }
                }
              },
              icon: const Icon(Icons.save),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: EnumOrderRegistrationPage.addProduct,
                  child: Text('Adicionar Produto'),
                ),
                const PopupMenuItem(
                  value: EnumOrderRegistrationPage.editProduct,
                  child: Text('Editar Produto'),
                ),
                const PopupMenuItem(
                  value: EnumOrderRegistrationPage.addClient,
                  child: Text('Adicionar Cliente'),
                ),
              ],
              onSelected: (value) async {
                if (value == EnumOrderRegistrationPage.addProduct) {
                  _showProductRegistrationPage();
                }
                else if (value == EnumOrderRegistrationPage.editProduct) {
                  if (_selectedProduct == null) {
                    _showSnackBarError('Nenhum produto selecionado');
                  } else {
                    _showProductRegistrationPage(product: _selectedProduct);
                  }
                }
                else if (value == EnumOrderRegistrationPage.addClient){
                  clientService.createOrUpdate(clientList: clientList, context: context);
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_selectedProduct != null) {
                _setOrderItem();
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
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onLongPress: () {
                            setState(() {
                              client = null;
                            });
                          },
                          onPressed: () async {
                            final selectedClient = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowClientListDialog(
                                    clientList: clientList),
                              ),
                            );
                            setState(() {
                              if (selectedClient != null) {
                                client = selectedClient;
                              }
                            });
                          },
                          child: Text(
                            client == null
                                ? 'Selecione o cliente'
                                : client!.name,
                            textAlign: TextAlign.center,
                          ),
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
                              fillColor: CustomColors.backgroundTile,
                              labelText: 'Quantidade',
                              labelStyle: const TextStyle(
                                  color: CustomColors.textColorTile),
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
                            style: const TextStyle(
                                color: CustomColors.textColorTile),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (e) async {
                              final productFromDialog = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShowProductListDialog(
                                            productList: productList,
                                          )));

                              if (productFromDialog != null &&
                                  productFromDialog is ProductData) {
                                setState(() {
                                  _selectedProduct = productFromDialog;
                                  _quantityFocus.requestFocus();
                                  _quantityController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _quantityController
                                          .value.text.length);
                                });
                              }
                            },
                            validator: (e) {
                              var regExp =
                                  RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                      .hasMatch(e!);
                              if (_quantityController.text.isEmpty || !regExp) {
                                return 'Quantidade Inválida';
                              }
                              return null;
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
                                      focusNode: _selectProductFocus,
                                      onLongPress: () {
                                        setState(() {
                                          _selectedProduct = null;
                                        });
                                      },
                                      onPressed: () async {
                                        final productFromDialog =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowProductListDialog(
                                                          productList:
                                                              productList,
                                                        )));

                                        if (productFromDialog != null &&
                                            productFromDialog is ProductData) {
                                          setState(() {
                                            _selectedProduct =
                                                productFromDialog;
                                            _quantityFocus.requestFocus();
                                          });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              _selectedProduct == null
                                                  ? 'Selecione um produto'
                                                  : _selectedProduct.toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          RectGetter(
                                            key: _rectKey,
                                            child: Flexible(
                                              flex: 1,
                                              fit: FlexFit.loose,
                                              child: IconButton(
                                                onPressed: () {
                                                  var rect =
                                                      RectGetter.getRectFromKey(
                                                          _rectKey);
                                                  _showPopUpMenu(rect!);
                                                },
                                                icon: const Icon(Icons.note),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
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
                          onRefresh: () {},
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
    OrderItemData verifyOrderItem =
        OrderItemData(quantity: 0, product: _selectedProduct!);
    if (orderItemList.contains(verifyOrderItem)) {
      _showSnackBarError('O produto já esta na lista');
    } else {
      orderItem = OrderItemData(
          quantity: int.parse(_quantityController.text),
          product: _selectedProduct!,
          note: note);
      setState(() {
        orderItemList.add(orderItem!);
        _clearFields();
      });
    }
  }

  _showSnackBarError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        backgroundColor: CustomColors.backgroundTile,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  }

  void _setOrder() {
    newOrder.client = client!;
    newOrder.creationDate =
        widget.order == null ? DateTime.now() : widget.order!.creationDate;
    newOrder.lengthOrderItemList = orderItemList.length;
    newOrder.enabled = true;
    newOrder.orderItemList = orderItemList;
  }

  void _clearFields() {
    _quantityFocus.requestFocus();
    _quantityController.text = '1';
    _quantityController.selection = TextSelection(
        baseOffset: 0, extentOffset: _quantityController.value.text.length);
    _noteController.text = '';
    note = null;

    _selectedProduct = null;
  }
}
