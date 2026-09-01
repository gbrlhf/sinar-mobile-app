import 'package:flutter/material.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantau PJU'),
      ),
      body: const Center(
        child: Text(
          'Halaman Pantau PJU',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
