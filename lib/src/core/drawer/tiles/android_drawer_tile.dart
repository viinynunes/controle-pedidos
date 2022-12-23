import 'package:flutter/material.dart';

class AndroidDrawerTile extends StatelessWidget {
  const AndroidDrawerTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
