import 'package:flutter/material.dart';
import 'package:medileaf/leaf_detector_screen.dart';

void main() {
  runApp(const MyApp());
}

// Test conflict...
// Temporary comment to test commit
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: LeafDetectorScreen(),
    );
  }
}
