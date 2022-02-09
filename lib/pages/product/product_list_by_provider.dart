import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
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

  @override
  void initState() {
    super.initState();
    _setProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.provider.name),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<ProductModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _setProductList,
              child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    var product = productList[index];
                    return ProductListTile(product: product);
                  }),
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
