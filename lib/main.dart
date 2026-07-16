import 'package:flutter/material.dart';
import 'features/provider_dashboard/provider_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KaziLink Provider Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ProviderDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
