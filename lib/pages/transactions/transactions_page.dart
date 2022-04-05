import 'package:controle_pedidos/data/order_data.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/services/transactions_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../widgets/tiles/transaction_list_tile.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<ProductData> productList = [];
  List<ProductData> filteredProductList = [];
  List<OrderData> orderList = [];

  final transactionService = TransactionsService();

  final _searchController = TextEditingController();

  bool isSearching = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    _updateProductList();
  }

  @override
  Widget build(BuildContext context) {

    final desktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  orderList.clear();
                  filteredProductList.clear();
                  _searchController.text = '';
                });
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: desktop ? 1080 : double.maxFinite
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar Produtos',
                    labelStyle: const TextStyle(color: CustomColors.textColorTile),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  style: const TextStyle(color: CustomColors.textColorTile),
                  onChanged: (text) {
                    _filterProductList(text);
                  },
                  keyboardType: TextInputType.url,
                ),
                loading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : isSearching
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: filteredProductList.length,
                              itemBuilder: (context, index) {
                                var product = filteredProductList[index];
                                return ListTile(
                                  title: Text(
                                    product.name + ' - ' + product.provider.name,
                                    style: const TextStyle(
                                        color: CustomColors.textColorTile),
                                  ),
                                  onTap: () {
                                    _searchController.text = product.name;
                                    _updateOrderList(product);
                                  },
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: orderList.length,
                              itemBuilder: (context, index) {
                                var order = orderList[index];
                                return TransactionListTile(order: order);
                              },
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProductList() async {
    if (mounted) {
      final list = await ProductModel.of(context).getFilteredEnabledProducts();

      setState(() {
        productList = list;
        filteredProductList.clear();
        filteredProductList.addAll(productList);
      });
    }
  }

  void _filterProductList(String search) {
    List<ProductData> _auxList = [];
    _auxList.addAll(productList);
    if (search.isNotEmpty) {
      List<ProductData> _filteredList = [];
      for (var product in _auxList) {
        if (product.name.toLowerCase().contains(search.toLowerCase())) {
          _filteredList.add(product);
        }
      }

      setState(() {
        isSearching = true;
        filteredProductList.clear();
        filteredProductList.addAll(_filteredList);
      });
      return;
    } else {
      setState(() {
        isSearching = false;
        filteredProductList.clear();
        filteredProductList.addAll(productList);
      });
    }
  }

  Future<void> _updateOrderList(ProductData product) async {
    setState(() {
      loading = true;
    });
    final list =
        await transactionService.getTransactionsByProduct(product, context);

    if (mounted) {
      setState(() {
        isSearching = false;
        orderList.clear();
        orderList = list;
        loading = false;
      });
    }
  }
}
