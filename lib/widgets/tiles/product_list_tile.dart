import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({Key? key, required this.product, required this.showRegistrationPage, required this.onDelete}) : super(key: key);

  final ProductData product;
  final VoidCallback showRegistrationPage;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<ProductModel>(
      builder: (context, child, model) => Slidable(
          key: const ValueKey(0),
          startActionPane: ActionPane(
            dismissible: null,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (e) {
                  onDelete();
                },
                icon: Icons.delete_forever,
                backgroundColor: Colors.red,
                label: 'Apagar',
              ),
              SlidableAction(
                onPressed: (e) {
                  showRegistrationPage();
                },
                icon: Icons.edit,
                backgroundColor: Colors.deepPurple,
                label: 'Editar',
              ),
            ],
          ),
          child: Card(
            color: CustomColors.backgroundTile,
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
                        style: const TextStyle(fontSize: 20, color: CustomColors.textColorTile),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text(
                        product.category,
                        style: const TextStyle(fontSize: 14, color: CustomColors.textColorTile),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text(
                        product.provider.name,
                        style: const TextStyle(fontSize: 14, color: CustomColors.textColorTile),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text(
                        product.provider.location,
                        style: const TextStyle(fontSize: 14, color: CustomColors.textColorTile),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
