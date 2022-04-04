import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/services/product_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class ShowProductListDialog extends StatefulWidget {
  const ShowProductListDialog(
      {Key? key, required this.productList, required this.selectedProduct, required this.longPressSelectedProduct})
      : super(key: key);

  final Function(ProductData) selectedProduct;
  final Function(ProductData) longPressSelectedProduct;
  final List<ProductData> productList;

  @override
  _ShowProductListDialogState createState() => _ShowProductListDialogState();
}

class _ShowProductListDialogState extends State<ShowProductListDialog> {
  List<ProductData> productList = [];
  List<ProductData> secondProductList = [];

  final productService = ProductService();

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

    final desktop = MediaQuery.of(context).size.width > 600;

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
            keyboardType: TextInputType.url,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () async {
                final recProd = await productService.createOrUpdate(
                    productList: productList, context: context);

                setState(() {
                  if (recProd != null) {
                    productService.sortProductsByName(productList);
                    _selectProduct(recProd);
                  }
                });
              },
              child: const Text('Criar novo produto'),
            ),
          )
        ],
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: desktop ? MediaQuery.of(context).size.width * 0.4 : double.maxFinite,
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
              onLongPress: (){
                _longPressSelectedProduct(item);
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

  void _longPressSelectedProduct(ProductData item){
    setState(() {
      widget.longPressSelectedProduct(item);
      Navigator.pop(context);
    });
  }
}
