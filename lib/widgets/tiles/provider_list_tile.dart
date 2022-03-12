import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/pages/product/product_list_by_provider.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class ProviderListTile extends StatelessWidget {
  const ProviderListTile({Key? key, required this.provider}) : super(key: key);

  final ProviderData provider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductListByProvider(provider: provider)));
      },
      child: Card(
        color: CustomColors.backgroundTile,
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Text(
                    provider.name,
                    style: const TextStyle(fontSize: 20, color: CustomColors.textColorTile),
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text(
                    provider.location,
                    style: const TextStyle(fontSize: 14, color: CustomColors.textColorTile),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    provider.establishment.name,
                    style: const TextStyle(fontSize: 14, color: CustomColors.textColorTile),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.arrow_right, color: CustomColors.textColorTile)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
