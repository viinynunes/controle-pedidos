import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/product_registration_page.dart';
import 'package:controle_pedidos/services/product_service.dart';
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
  String? search;
  List<ProductData> productList = [];

  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _updateProductList();
  }

  void _showProductRegistrationPage({ProductData? product}) async {
    final recProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => product == null
            ? const ProductRegistrationPage()
            : ProductRegistrationPage(
                product: product,
              ),
      ),
    );

    if (recProduct != null) {
      if (product != null) {
        ProductModel.of(context).updateProduct(recProduct);
      } else {
        setState(() {
          ProductModel.of(context).createProduct(recProduct);
          productList.add(recProduct);
          productService.sortProductsByName(productList);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (text.isEmpty) {
                    search = null;
                  } else {
                    search = text;
                  }
                },
              )
            : const Text('Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  search = null;
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
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: productList.length,
        itemBuilder: (context, index) {
          var product = productList[index];
          return ProductListTile(product: product);
        },
      ),
    );
  }

  Future<void> _updateProductList() async {
    setState(() {
      loading = true;
    });
    final list = await ProductModel.of(context)
        .getFilteredEnabledProducts(search: search);

    setState(() {
      productList = list;
      loading = false;
    });
  }
}
