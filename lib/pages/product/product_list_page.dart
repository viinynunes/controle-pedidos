import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/services/product_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/product_list_tile.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final productService = ProductService();

  bool isSearching = false;
  bool loading = false;
  List<ProductData> productList = [];
  List<ProductData> secondaryProductList = [];

  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _updateProductList();
  }

  void _showProductRegistrationPage({ProductData? product}) async {
    setState(() {
      loading = true;
    });
    await productService.createOrUpdate(
        product: product, productList: productList, context: context);

    setState(() {
      _updateProductList();
      productService.sortProductsByName(secondaryProductList);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                focusNode: _searchFocus,
                decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    hintText: 'Pesquisar',
                    hintStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white, fontSize: 22),
                onChanged: (text) async {
                  _filterProduct(text);
                },
              )
            : const Text('Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isSearching) {
                  _clearSearchFromSecondaryList();
                  isSearching = false;
                } else {
                  isSearching = true;
                  _searchFocus.requestFocus();
                }
              });
            },
            icon: isSearching
                ? const Icon(Icons.cancel)
                : const Icon(Icons.search),
          ),
        ],
      ),
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showProductRegistrationPage();
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: desktop ? 1080 : double.maxFinite),
                child: ListView.builder(
                  itemCount: secondaryProductList.length,
                  itemBuilder: (context, index) {
                    var product = secondaryProductList[index];
                    return ProductListTile(
                      product: product,
                      showRegistrationPage: () {
                        _showProductRegistrationPage(product: product);
                      },
                      onDelete: (){
                        setState(() {
                          ProductModel.of(context).disableProduct(product);
                          productList.remove(product);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }

  Future<void> _updateProductList() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
      final list = await ProductModel.of(context).getFilteredEnabledProducts();

      setState(() {
        productList = list;
        secondaryProductList.clear();
        secondaryProductList.addAll(productList);
        loading = false;
      });
    }
  }

  void _filterProduct(String search) {
    List<ProductData> changeList = [];
    changeList.addAll(productList);
    if (search.isNotEmpty) {
      List<ProductData> filteredList = [];
      for (var product in changeList) {
        if (product.name.toLowerCase().contains(search.toLowerCase())) {
          filteredList.add(product);
        }
      }

      setState(() {
        secondaryProductList.clear();
        secondaryProductList.addAll(filteredList);
      });
      return;
    } else {
      _clearSearchFromSecondaryList();
    }
  }

  void _clearSearchFromSecondaryList() {
    setState(() {
      secondaryProductList.clear();
      secondaryProductList.addAll(productList);
    });
  }
}
