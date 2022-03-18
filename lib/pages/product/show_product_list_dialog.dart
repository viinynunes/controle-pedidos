import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class ShowProductListDialog extends StatefulWidget {
  const ShowProductListDialog(
      {Key? key, required this.productList, required this.selectedProduct})
      : super(key: key);

  final Function(ProductData) selectedProduct;
  final List<ProductData> productList;

  @override
  _ShowProductListDialogState createState() => _ShowProductListDialogState();
}

class _ShowProductListDialogState extends State<ShowProductListDialog> {
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
    return AlertDialog(
      elevation: 50,
      backgroundColor: CustomColors.backgroundColor,
      title: Column(
        children: [
          const Text(
            'Selecione um produto',
            textAlign: TextAlign.center,
            style: TextStyle(color: CustomColors.textColorTile),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _searchController,
            focusNode: _searchNode,
            decoration: InputDecoration(
              labelText: 'Procurar Produto',
              labelStyle: const TextStyle(color: CustomColors.textColorTile),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
            ),
            style: const TextStyle(color: CustomColors.textColorTile),
            onChanged: (e) {
              _filterProductList(e);
            },
            onSubmitted: (e) {
              _selectProduct(secondProductList.first);
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
              textColor: CustomColors.textColorTile,
              title: Text(item.toString()),
              onTap: () {
                _selectProduct(item);
              },
            );
          },
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

  void _selectProduct(ProductData item) {
    setState(() {
      widget.selectedProduct(item);
      Navigator.pop(context);
    });
  }
}
