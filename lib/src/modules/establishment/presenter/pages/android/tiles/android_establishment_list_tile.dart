import 'package:flutter/material.dart';

import '../../../../../../domain/entities/establishment.dart';

class AndroidEstablishmentListTile extends StatefulWidget {
  const AndroidEstablishmentListTile(
      {Key? key, required this.establishment, required this.onTap})
      : super(key: key);

  final Establishment establishment;
  final VoidCallback onTap;

  @override
  _AndroidEstablishmentListTileState createState() =>
      _AndroidEstablishmentListTileState();
}

class _AndroidEstablishmentListTileState
    extends State<AndroidEstablishmentListTile> {
  @override
  Widget build(BuildContext context) {
    final enabled = widget.establishment.enabled;

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
                  widget.establishment.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  enabled ? 'Ativado' : 'Desativado',
                  textAlign: TextAlign.end,
                  style: enabled
                      ? Theme.of(context).textTheme.labelSmall
                      : const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
