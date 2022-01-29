import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: InitializePage(),
  ));
}

class InitializePage extends StatelessWidget {
  const InitializePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
      ),
    );
  }
}
