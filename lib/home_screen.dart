import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasker/task.dart';
import 'package:tasker/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [
    Task(DateTime.now().toString() + Random().nextInt(100).toString(), "Task",
        false),
    Task(DateTime.now().toString() + Random().nextInt(100).toString(), "Task2",
        false),
  ];
  final _titleController = TextEditingController();

  void addTask() {
    var newTask = Task(
      DateTime.now().toString() + Random().nextInt(100).toString(),
      _titleController.text,
      false,
    );
    setState(() {
      _tasks.add(newTask);
    });
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
          showModalBottomSheet(
            enableDrag: true,
            context: context,
            builder: (context) {
              return Column(
                children: [
                  TextField(
                    onSubmitted: (value) {
                      addTask();
                      _titleController.clear();
                      Navigator.pop(context);
                    },
                    controller: _titleController,
                  ),
                  ElevatedButton(
                      onPressed: (() {
                        addTask();
                        _titleController.clear();
                        Navigator.pop(context);
                      }),
                      child: const Text('ADD')),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
