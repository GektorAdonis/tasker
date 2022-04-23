import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tasker/task.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  TaskList(this.tasks);
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void _toggleIsComplete(String id) {
    var searchedTask = widget.tasks.firstWhere((task) => task.id == id);
    setState(() {
      searchedTask.isComplete = !searchedTask.isComplete;
    });

    Timer t = Timer(const Duration(seconds: 5), () {
      if (searchedTask.isComplete == true) {
        setState(() {
          widget.tasks.removeWhere((task) => task.id == id);
        });
      }
    });

    if (searchedTask.isComplete == false) {
      t.cancel();
    }

    void removeTask(String id) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return ListTile(
          onTap: () {
            _toggleIsComplete(widget.tasks[i].id);
          },
          title: Text(widget.tasks[i].title),
          leading: Icon(
            widget.tasks[i].isComplete ? Icons.circle : Icons.circle_outlined,
          ),
        );
      },
      itemCount: widget.tasks.length,
    );
  }
}
