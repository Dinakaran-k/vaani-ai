import 'package:flutter/material.dart';

class OcrScreen extends StatelessWidget {
  const OcrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan invoice')),
      body: const Center(child: Text('Camera OCR workflow')),
    );
  }
}
