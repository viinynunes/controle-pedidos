import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/services/stock_default_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
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
        backgroundColor: CustomColors.backgroundColor,
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              child: Text(
                'Produtos Padrão',
                style: TextStyle(color: CustomColors.textColorTile),
              ),
              icon: Icon(
                Icons.check_box_outlined,
                color: CustomColors.textColorTile,
              ),
            ),
            Tab(
              child: Text(
                'Todos Produtos',
                style: TextStyle(color: CustomColors.textColorTile),
              ),
              icon: Icon(
                Icons.list,
                color: CustomColors.textColorTile,
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
                        labelStyle: TextStyle(color: CustomColors.textColorTile),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      style: const TextStyle(color: CustomColors.textColorTile),
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
                                side: const BorderSide(color: CustomColors.textColorTile),
                                title: Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(item.name, style: const TextStyle(color: CustomColors.textColorTile),),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.provider.name,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(color: CustomColors.textColorTile),
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
                        labelStyle: TextStyle(color: CustomColors.textColorTile),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      style: const TextStyle(color: CustomColors.textColorTile),
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
                                side: const BorderSide(color: CustomColors.textColorTile),
                                title: Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(item.name, style: const TextStyle(color: CustomColors.textColorTile),),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.provider.name,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(color: CustomColors.textColorTile),
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
