import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasker/task.dart';
import 'package:tasker/task_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  List<Task> _tasks = [
    Task(DateTime.now().toString() + Random(100).toString(), "Task", false),
    Task(DateTime.now().toString() + Random(100).toString(), "Task2", false),
  ];
  final _titleController = TextEditingController();

  void addTask() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            TextField(
              controller: _titleController,
            )
          ],
        );
      },
    );

    var newTask = Task(
      DateTime.now().toString() + Random(100).toString(),
      _titleController.text,
      false,
    );
    setState(() {
      _tasks.add(newTask);
    });
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasker"),
      ),
      body: TaskList(_tasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTask();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
