import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/product_registration_page.dart';
import 'package:controle_pedidos/widgets/tiles/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {



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
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: const Text('Produtos'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showProductRegistrationPage();
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<ProductData>>(
          future: model.getAllEnabledProducts(),
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
                    return Slidable(
                      key: const ValueKey(0),
                        startActionPane: ActionPane(
                          dismissible: null,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (e) {
                                setState(() {
                                  model.disableProduct(product);
                                });
                              },
                              icon: Icons.delete_forever,
                              backgroundColor: Colors.red,
                              label: 'Apagar',
                            ),
                            SlidableAction(
                              onPressed: (e) {
                                setState(() {
                                  _showProductRegistrationPage(product: product);
                                });
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.deepPurple,
                              label: 'Editar',
                            ),
                          ],
                        ),
                        child: ProductListTile(
                      product: product,
                    ));
                  });
            }
          },
        ),
      ),
    );
  }
}
