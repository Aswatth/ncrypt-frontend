import 'package:flutter/material.dart';
import 'package:frontend/clients/env_loader.dart';
import 'package:frontend/home.dart';

void main() async {
  await EnvLoader().load("L:\\MyProjects\\Ncrypt\\backend\\.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ncrypt',
      // home: MyHomePage(title: 'Ncrypt'),
      home: HomePage()
    );
  }
}