import 'package:flutter/material.dart';

class AddRemoveQuantityWidget extends StatelessWidget {
  const AddRemoveQuantityWidget(
      {Key? key, required this.onTap, required this.icon, required this.color})
      : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 18,
        color: color,
      ),
    );
  }
}
