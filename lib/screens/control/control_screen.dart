import 'package:flutter/material.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontrol PJU'),
      ),
      body: const Center(
        child: Text(
          'Halaman Kontrol PJU',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
