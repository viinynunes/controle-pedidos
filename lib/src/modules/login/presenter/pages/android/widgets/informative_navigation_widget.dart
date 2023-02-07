import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InformativeNavigationWidget extends StatelessWidget {
  const InformativeNavigationWidget(
      {Key? key,
      required this.informativeText,
      required this.actionText,
      required this.onTap})
      : super(key: key);

  final String informativeText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: AutoSizeText(
            informativeText,
            maxLines: 1,
            minFontSize: 5,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: onTap,
            child: AutoSizeText(
              actionText,
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
