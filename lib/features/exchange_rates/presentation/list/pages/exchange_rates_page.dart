import 'package:flutter/material.dart';

class ExchangeRatesPage extends StatelessWidget {
  const ExchangeRatesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Currency Exchange Tracker')),
    body: const Center(child: Text('Exchange rates will appear here.')),
  );
}
