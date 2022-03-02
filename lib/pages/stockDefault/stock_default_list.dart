import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/services/stock_default_service.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';

class StockDefaultList extends StatefulWidget {
  const StockDefaultList({Key? key}) : super(key: key);

  @override
  _StockDefaultListState createState() => _StockDefaultListState();
}

class _StockDefaultListState extends State<StockDefaultList> {
  bool loading = false;
  bool? checked = true;
  List<ProductData> productList = [];
  List<ProductData> productStockDefaultList = [];

  final _stockDefaultService = StockDefaultService();

  @override
  void initState() {
    super.initState();
  }

  void _updateStockDefaultProperty(ProductData product) {
    ProductModel.of(context).updateProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Produtos Padrão'),
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              child: Text(
                'Produtos Padrão',
                style: TextStyle(color: Colors.black),
              ),
              icon: Icon(
                Icons.check_box_outlined,
                color: Colors.black,
              ),
            ),
            Tab(
              child: Text(
                'Todos Produtos',
                style: TextStyle(color: Colors.black),
              ),
              icon: Icon(
                Icons.list,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Form(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Produtos',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<ProductData>>(
                    future: _setProductDefaultList(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: productStockDefaultList.length,
                            itemBuilder: (context, index) {
                              var item = productStockDefaultList[index];

                              return CheckboxListTile(
                                key: Key(item.id.toString()),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: item.stockDefault,
                                onChanged: (e) {
                                  if (e != null) {
                                    setState(() {
                                      item.stockDefault = e;
                                      _updateStockDefaultProperty(item);
                                    });
                                  }
                                },
                                title: Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(item.name),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.provider.name,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Form(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Produtos',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<ProductData>>(
                    future: _setProductList(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              var item = productList[index];

                              return CheckboxListTile(
                                key: Key(item.id.toString()),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: item.stockDefault,
                                onChanged: (e) {
                                  if (e != null) {
                                    setState(() {
                                      item.stockDefault = e;
                                      _updateStockDefaultProperty(item);
                                    });
                                  }
                                },
                                title: Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(item.name),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.provider.name,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ProductData>> _setProductList() async {
    setState(() {
      loading = true;
    });

    final list = await ProductModel.of(context).getFilteredEnabledProducts();

    _stockDefaultService.orderProductsByProviderAndName(list);

    setState(() {
      productList = list;
      loading = false;
    });

    return productList;
  }

  Future<List<ProductData>> _setProductDefaultList() async {
    setState(() {
      loading = true;
    });

    final list =
        await ProductModel.of(context).getEnabledProductsByStockDefaultTrue();

    _stockDefaultService.orderProductsByProviderAndName(list);

    setState(() {
      productStockDefaultList = list;
      loading = false;
    });

    return productStockDefaultList;
  }
}
