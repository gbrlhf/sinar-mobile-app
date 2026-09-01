import 'package:flutter/material.dart';

class ConditionScreen extends StatelessWidget {
  const ConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kondisi PJU'),
      ),
      body: const Center(
        child: Text(
          'Halaman Kondisi PJU',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
