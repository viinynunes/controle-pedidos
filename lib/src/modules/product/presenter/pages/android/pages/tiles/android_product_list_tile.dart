import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/product.dart';

class AndroidProductListTile extends StatelessWidget {
  const AndroidProductListTile(
      {Key? key, required this.product, required this.onTap})
      : super(key: key);

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = product.enabled;

    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.providerName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      product.category,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      enabled ? 'Ativado' : 'Desativado',
                      style: enabled
                          ? Theme.of(context).textTheme.labelSmall
                          : null,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
