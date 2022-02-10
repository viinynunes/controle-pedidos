import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/client_model.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key, this.client}) : super(key: key);

  ClientData? client;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<ClientData> clientList = [];
  List<ProductData> productList = [];


  ProductData? _selectedProduct;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setClientList();
    _setProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //Line with quantity and product
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 60,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Quantidade',
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
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: DropdownSearch<ProductData>(
                          items: productList,
                          selectedItem: _selectedProduct,
                          showSearchBox: true,
                          dropdownSearchDecoration: InputDecoration(
                            label: const Text('Selecione o produto'),
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
                              _selectedProduct = e;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
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
}
