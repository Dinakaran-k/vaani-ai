import 'package:flutter/material.dart';

class PaymentRemindersScreen extends StatelessWidget {
  const PaymentRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment reminders')),
      body: const Center(child: Text('SMS, WhatsApp and email reminders')),
    );
  }
}
