import 'package:flutter/material.dart';

class OrderRegistrationMenu extends StatelessWidget {
  const OrderRegistrationMenu(
      {Key? key,
      this.onEditClient,
      this.onRemoveClient,
      this.onEditProduct,
      this.onRemoveProduct})
      : super(key: key);

  final VoidCallback? onEditClient;
  final VoidCallback? onRemoveClient;
  final VoidCallback? onEditProduct;
  final VoidCallback? onRemoveProduct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            onEditClient != null
                ? Column(
                    children: [
                      ListTile(
                        onTap: onEditClient,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.account_circle,
                            ),
                          ],
                        ),
                        title: const Text('Editar Cliente'),
                        subtitle: const Text(
                            'Altere as informações do cliente selecionado'),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            onRemoveClient != null
                ? Column(
                    children: [
                      ListTile(
                        onTap: onRemoveClient,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove,
                              color: Theme.of(context).errorColor,
                            ),
                          ],
                        ),
                        title: Text(
                          'Remover Cliente',
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                        subtitle: Text(
                          'Remove o cliente selecionado',
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            onEditProduct != null
                ? Column(
                    children: [
                      ListTile(
                        onTap: onEditProduct,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.production_quantity_limits,
                            ),
                          ],
                        ),
                        title: const Text('Editar Produto'),
                        subtitle: const Text('Edite o produto selecionado'),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            onRemoveProduct != null
                ? Column(
                    children: [
                      ListTile(
                        onTap: onRemoveProduct,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.remove,
                                color: Theme.of(context).errorColor),
                          ],
                        ),
                        title: Text('Remover Produto',
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            )),
                        subtitle: Text('Remove o produto selecionado',
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            )),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
