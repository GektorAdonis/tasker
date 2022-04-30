import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasker/task.dart';
import 'package:http/http.dart' as http;

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  TaskList(this.tasks);
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DateFormat format = DateFormat('yyyy-MM-dd H:m');
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
          trailing: Text(
            widget.tasks[i].date == null
                ? ''
                : format.format(widget.tasks[i].date),
          ),
        );
      },
      itemCount: widget.tasks.length,
    );
  }
}
