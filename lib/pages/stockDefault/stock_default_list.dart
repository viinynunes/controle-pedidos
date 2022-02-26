import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/widgets/tiles/product_list_tile.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';

class StockDefaultList extends StatefulWidget {
  const StockDefaultList({Key? key}) : super(key: key);

  @override
  _StockDefaultListState createState() => _StockDefaultListState();
}

class _StockDefaultListState extends State<StockDefaultList> {
  bool loading = false;

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
        title: const Text('Editar Produtos Padrão'),
      ),
      body: Padding(
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
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  var item = productList[index];

                  return ProductListTile(product: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setProductList() async {
    setState(() {
      loading = true;
    });

    final list = await ProductModel.of(context).getFilteredEnabledProducts();

    setState(() {
      productList = list;
      loading = false;
    });
  }
}
