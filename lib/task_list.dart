import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasker/task.dart';
import 'package:http/http.dart' as http;

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  TaskList(this.tasks);
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<void> _toggleIsComplete(String id) async {
    var searchedTask = widget.tasks.firstWhere((task) => task.id == id);
    final url = Uri.parse(
        'https://tasker-cd27d-default-rtdb.firebaseio.com/tasks/$id.json');
    setState(() {
      searchedTask.isComplete = !searchedTask.isComplete;
    });
    var response = await http.patch(
      url,
      body: json.encode({
        'isComplete': searchedTask.isComplete,
      }),
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return ListTile(
          onTap: () {
            print(widget.tasks[i].id);
            _toggleIsComplete(widget.tasks[i].id);
          },
          title: Text(widget.tasks[i].title),
          leading: Icon(
            widget.tasks[i].isComplete ? Icons.circle : Icons.circle_outlined,
          ),
          trailing: Text(widget.tasks[i].date == null
              ? ''
              : widget.tasks[i].date.toString()),
        );
      },
      itemCount: widget.tasks.length,
    );
  }
}
