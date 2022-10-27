import 'package:flutter/material.dart';

import '../../../../domain/entities/client.dart';

class AndroidClientListTile extends StatefulWidget {
  const AndroidClientListTile(
      {Key? key, required this.client, required this.onTap})
      : super(key: key);

  final Client client;
  final VoidCallback onTap;

  @override
  _AndroidClientListTileState createState() => _AndroidClientListTileState();
}

class _AndroidClientListTileState extends State<AndroidClientListTile> {
  @override
  Widget build(BuildContext context) {
    final enabled = widget.client.enabled;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  widget.client.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.client.phone,
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      widget.client.email,
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      enabled ? 'Ativado' : 'Desativado',
                      style: enabled
                          ? Theme.of(context).textTheme.labelSmall
                          : const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
