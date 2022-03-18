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

  List<ProductData> filteredProductList = [];
  List<ProductData> filteredProductStockDefaultList = [];

  final _stockDefaultService = StockDefaultService();

  @override
  void initState() {
    super.initState();

    _setProductList();
    _setProductDefaultList();
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
          actions: [
            IconButton(
              onPressed: () {
                _setProductList();
                _setProductDefaultList();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
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
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Form(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Produtos',
                              labelStyle: const TextStyle(
                                  color: CustomColors.textColorTile),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            style: const TextStyle(
                                color: CustomColors.textColorTile),
                            onChanged: (text) {
                              _filterProductStockDefaultList(text);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredProductStockDefaultList.length,
                            itemBuilder: (context, index) {
                              var item = filteredProductStockDefaultList[index];

                              return CheckboxListTile(
                                key: Key(item.id.toString()),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: item.stockDefault,
                                onChanged: (e) {
                                  if (e != null) {
                                    setState(() {
                                      item.stockDefault = e;
                                      filteredProductStockDefaultList
                                          .remove(item);
                                      _updateStockDefaultProperty(item);
                                      _setProductList();
                                    });
                                  }
                                },
                                side: const BorderSide(
                                    color: CustomColors.textColorTile),
                                title: Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                            color: CustomColors.textColorTile),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.provider.name,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            color: CustomColors.textColorTile),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Form(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Produtos',
                              labelStyle: const TextStyle(
                                  color: CustomColors.textColorTile),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            style: const TextStyle(
                                color: CustomColors.textColorTile),
                            onChanged: (text) {
                              _filterProductList(text);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredProductList.length,
                            itemBuilder: (context, index) {
                              var item = filteredProductList[index];
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
                                      _setProductDefaultList();
                                    });
                                  }
                                },
                                side: const BorderSide(
                                    color: CustomColors.textColorTile),
                                title: Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                            color: CustomColors.textColorTile),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        item.provider.name,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            color: CustomColors.textColorTile),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<List<ProductData>> _setProductList() async {
    if(mounted){
      setState(() {
        loading = true;
      });

      final list = await ProductModel.of(context).getFilteredEnabledProducts();

      _stockDefaultService.orderProductsByProviderAndName(list);

      setState(() {
        productList = list;
        filteredProductList.addAll(productList);
        loading = false;
      });
    }
    return productList;
  }

  Future<List<ProductData>> _setProductDefaultList() async {
    if(mounted){
      setState(() {
        loading = true;
      });

      final list =
      await ProductModel.of(context).getEnabledProductsByStockDefaultTrue();

      _stockDefaultService.orderProductsByProviderAndName(list);

      setState(() {
        productStockDefaultList = list;
        filteredProductStockDefaultList.clear();
        filteredProductStockDefaultList.addAll(productStockDefaultList);
        loading = false;
      });
    }


    return productStockDefaultList;
  }

  void _filterProductList(String search) {
    List<ProductData> auxList = [];
    auxList.addAll(productList);
    if (search.isNotEmpty) {
      List<ProductData> _filteredList = [];
      for (var p in auxList) {
        if (p.name.toLowerCase().contains(search.toLowerCase()) ||
            p.provider.name.toLowerCase().contains(search.toLowerCase())) {
          _filteredList.add(p);
        }
      }
      setState(() {
        filteredProductList.clear();
        filteredProductList.addAll(_filteredList);
      });
      return;
    } else {
      setState(() {
        filteredProductList.clear();
        filteredProductList.addAll(productList);
      });
    }
  }

  void _filterProductStockDefaultList(String search) {
    List<ProductData> auxList = [];
    auxList.addAll(productStockDefaultList);
    if (search.isNotEmpty) {
      List<ProductData> _filteredList = [];
      for (var p in auxList) {
        if (p.name.toLowerCase().contains(search.toLowerCase())) {
          _filteredList.add(p);
        }
      }
      setState(() {
        filteredProductStockDefaultList.clear();
        filteredProductStockDefaultList.addAll(_filteredList);
      });
      return;
    } else {
      setState(() {
        filteredProductStockDefaultList.clear();
        filteredProductStockDefaultList.addAll(productList);
      });
    }
  }
}
