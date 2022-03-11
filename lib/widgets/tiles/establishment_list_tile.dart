import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class EstablishmentListTile extends StatelessWidget {
  const EstablishmentListTile({Key? key, required this.establishment})
      : super(key: key);

  final EstablishmentData establishment;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.backgroundTile,
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                establishment.name,
                style: const TextStyle(fontSize: 20, color: CustomColors.textColorTile),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
