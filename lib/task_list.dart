import 'package:flutter/material.dart';
import 'package:tasker/task.dart';

class TaskList extends StatefulWidget {
  final tasks;
  TaskList(this.tasks);
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void _toggleIsComplete(String id) {
    var searchedTask = widget.tasks.firstWhere((task) => task.id == id);
    print(searchedTask.id);
    setState(() {
      searchedTask.isComplete = !searchedTask.isComplete;
    });
    if (searchedTask.isComplete == true) {
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          widget.tasks.removeWhere((task) => task.id == id);
        });
      });
    }
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
