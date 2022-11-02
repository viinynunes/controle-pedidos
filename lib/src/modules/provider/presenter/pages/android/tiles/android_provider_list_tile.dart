import 'package:controle_pedidos/src/modules/provider/domain/entities/provider.dart';
import 'package:flutter/material.dart';

class AndroidProviderListTile extends StatelessWidget {
  const AndroidProviderListTile(
      {Key? key, required this.provider, required this.onTap})
      : super(key: key);

  final Provider provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = provider.enabled;

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
                  provider.name,
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
                      provider.location,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      provider.establishmentName,
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
