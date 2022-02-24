import 'package:flutter/material.dart';

void main() {
  runApp(TaskerApp());
}

class TaskerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tasker App",
      home: Scaffold(),
    );
  }
}
