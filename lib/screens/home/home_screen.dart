import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda SINAR'),
      ),
      body: const Center(
        child: Text(
          'Halaman Beranda',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
