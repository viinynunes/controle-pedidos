import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/product_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({Key? key, required this.product}) : super(key: key);

  final ProductData product;

  @override
  Widget build(BuildContext context) {
    void _showProductRegistrationPage({required ProductData product}) async {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductRegistrationPage(
                    product: product,
                  )));
    }

    return ScopedModelDescendant<ProductModel>(
      builder: (context, child, model) => Slidable(
          key: const ValueKey(0),
          startActionPane: ActionPane(
            dismissible: null,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (e) {
                  model.disableProduct(product);
                },
                icon: Icons.delete_forever,
                backgroundColor: Colors.red,
                label: 'Apagar',
              ),
              SlidableAction(
                onPressed: (e) {
                  _showProductRegistrationPage(product: product);
                },
                icon: Icons.edit,
                backgroundColor: Colors.deepPurple,
                label: 'Editar',
              ),
            ],
          ),
          child: InkWell(
            onTap: () {},
            child: Card(
              child: SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          product.category,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          product.provider.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
