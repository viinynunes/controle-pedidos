import 'package:controle_pedidos/data/product_data.dart';
import 'package:flutter/material.dart';

class ShowProductListDialog extends StatefulWidget {
  const ShowProductListDialog({Key? key, required this.productList})
      : super(key: key);

  final List<ProductData> productList;

  @override
  _ShowProductListDialogState createState() => _ShowProductListDialogState();
}

class _ShowProductListDialogState extends State<ShowProductListDialog> {
  ProductData? product;
  List<ProductData> productList = [];
  List<ProductData> secondProductList = [];

  final _searchController = TextEditingController();
  final _searchNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.productList.isNotEmpty) {
      productList = widget.productList;
      secondProductList.addAll(productList);
    }

    _searchNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        elevation: 50,
        title: Column(
          children: [
            const Text(
              'Selecione um produto',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: _searchController,
              focusNode: _searchNode,
              decoration: const InputDecoration(
                labelText: 'Procurar Produto',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onChanged: (e) {
                _filterProductList(e);
              },
              onSubmitted: (e){
                setState(() {
                  product = secondProductList.first;
                  Navigator.pop(context, product);
                });
              },
            ),
          ],
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: secondProductList.length,
            itemBuilder: (context, index) {
              var item = secondProductList[index];
              return ListTile(
                title: Text(item.toString()),
                onTap: () {
                  setState(() {
                    product = item;
                    Navigator.pop(context, product);
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _filterProductList(String search) {
    List<ProductData> filteredList = [];
    filteredList.addAll(productList);
    if (search.isNotEmpty) {
      List<ProductData> xList = [];
      for (var element in filteredList) {
        if (element.name.toLowerCase().contains(search.toLowerCase())) {
          xList.add(element);
        }
      }

      setState(() {
        secondProductList.clear();
        secondProductList.addAll(xList);
      });
      return;
    } else {
      setState(() {
        secondProductList.clear();
        secondProductList.addAll(productList);
      });
    }
  }
}
