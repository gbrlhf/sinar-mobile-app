import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanya PJU'),
      ),
      body: const Center(
        child: Text(
          'Halaman Tanya PJU (Chatbot)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
