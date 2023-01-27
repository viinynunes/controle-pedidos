import 'package:flutter/material.dart';

class AddRemoveQuantityWidget extends StatelessWidget {
  const AddRemoveQuantityWidget(
      {Key? key, required this.onTap, required this.icon, required this.color, this.enabled = true})
      : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => enabled ? onTap : null,
      child: Icon(
        icon,
        size: 18,
        color: enabled ? color : Colors.black,
      ),
    );
  }
}
