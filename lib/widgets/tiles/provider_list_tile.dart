import 'package:controle_pedidos/data/provider_data.dart';
import 'package:flutter/material.dart';

class ProviderListTile extends StatelessWidget {
  const ProviderListTile({Key? key, required this.provider}) : super(key: key);

  final ProviderData provider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                    provider.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    provider.location,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    provider.establishment!.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
