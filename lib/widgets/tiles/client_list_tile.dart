import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class ClientListTile extends StatefulWidget {
  const ClientListTile({Key? key, required this.client}) : super(key: key);

  final ClientData client;

  @override
  _ClientListTileState createState() => _ClientListTileState();
}

class _ClientListTileState extends State<ClientListTile> {
  @override
  Widget build(BuildContext context) {
    ClientData client = widget.client;
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
                client.name,
                style: const TextStyle(fontSize: 20, color: CustomColors.textColorTile),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
