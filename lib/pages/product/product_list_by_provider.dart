import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/product_registration_page.dart';
import 'package:controle_pedidos/services/product_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/tiles/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListByProvider extends StatefulWidget {
  const ProductListByProvider({Key? key, required this.provider})
      : super(key: key);

  final ProviderData provider;

  @override
  _ProductListByProviderState createState() => _ProductListByProviderState();
}

class _ProductListByProviderState extends State<ProductListByProvider> {
  List<ProductData> productList = [];
  final service = ProductService();

  @override
  void initState() {
    super.initState();
    _setProductList();
  }

  void _showProductRegistrationPage({ProductData? product}) async {
    final recProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductRegistrationPage(
          product: product,
        ),
      ),
    );

    if (recProduct != null) {
      if (product != null) {
        setState(() {
          ProductModel.of(context).updateProduct(recProduct);
          productList.remove(product);
        });
      } else {
        ProductModel.of(context).createProduct(recProduct);
      }
      setState(() {
        productList.add(recProduct);
      });
    }

    service.sortProductsByName(productList);
  }

  @override
  Widget build(BuildContext context) {

    final desktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.provider.name),
        centerTitle: true,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: ScopedModelDescendant<ProductModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return productList.isEmpty
                ? const Center(
                    child: Text(
                      ('Nenhum producto encontrado'),
                      style: TextStyle(color: CustomColors.textColorTile),
                    ),
                  )
                : Center(
                  child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: desktop ? 1080 : double.maxFinite
              ),
                    child: RefreshIndicator(
                        onRefresh: _setProductList,
                        child: ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              var product = productList[index];
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
                            }),
                      ),
                  ),
                );
          }
        },
      ),
    );
  }

  Future<void> _setProductList() async {
    final list = await ProductModel.of(context)
        .getEnabledProductsFromProvider(provider: widget.provider);

    setState(() {
      productList = list;
    });
  }
}
