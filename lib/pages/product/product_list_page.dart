import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/product_registration_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool isSearching = false;
  String? search;

  final _searchFocus = FocusNode();

  void _showProductRegistrationPage({ProductData? product}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => product == null
                ? const ProductRegistrationPage()
                : ProductRegistrationPage(
                    product: product,
                  )));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductModel>(
      builder: (context, child, model) {
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
                      await model.getFilteredEnabledProducts(search: text);
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
          drawer: CustomDrawer(pageController: widget.pageController,),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showProductRegistrationPage();
            },
            child: const Icon(Icons.add),
          ),
          body: FutureBuilder<List<ProductData>>(
            future: model.getFilteredEnabledProducts(search: search),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return ProductListTile(
                            product: product);
                    });
              }
            },
          ),
        );
      },
    );
  }
}
