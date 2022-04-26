import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasker/task.dart';
import 'package:tasker/task_list.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  final _titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    fetchTasks();
    super.initState();
  }

  Future<void> fetchTasks() async {
    final List<Task> loadedTasks = [];
    final url = Uri.parse(
        'https://tasker-cd27d-default-rtdb.firebaseio.com/tasks.json');
    final response = await http.get(url);
    final extractedData;
    try {
      extractedData = json.decode(response.body) as Map<String, dynamic>;
    } catch (error) {
      rethrow;
    }

    extractedData.forEach((key, value) async {
      if (value['isComplete'] == false) {
        loadedTasks.add(
          Task(
            key,
            value['title'],
            DateTime.parse(value['date']),
            value['isComplete'],
          ),
        );
      } else {
        final delUrl = Uri.parse(
            'https://tasker-cd27d-default-rtdb.firebaseio.com/tasks/$key.json');
        http.delete(delUrl);
      }
    });
    _tasks = loadedTasks.toList();
    setState(() {});
  }

  Future<void> deleteCompletedTasks() async {
    final url = Uri.parse(
        'https://tasker-cd27d-default-rtdb.firebaseio.com/tasks.json');
  }

  Future<void> addTask(Task newTask) async {
    final url = Uri.parse(
        'https://tasker-cd27d-default-rtdb.firebaseio.com/tasks.json');
    newTask.title = _titleController.text;
    await http.post(url,
        body: json.encode({
          'title': newTask.title,
          'date': newTask.date.toString(),
          'isComplete': newTask.isComplete,
        }));

    setState(() {
      _tasks.add(newTask);
    });
  }

  void showModal() {
    var newTask = Task(
      DateTime.now().toString() + Random().nextInt(100).toString(),
      '',
      DateTime.now(),
      false,
    );
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextField(
              onSubmitted: (value) {
                addTask(newTask);
                _titleController.clear();
                Navigator.pop(context);
              },
              controller: _titleController,
            ),
            CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.utc(DateTime.now().year + 10),
                onDateChanged: (date) {
                  newTask.date = date;
                  // await showTimePicker(
                  //   context: context,
                  //   initialTime: TimeOfDay.now(),
                  // );
                }),
            ElevatedButton(
                onPressed: (() {
                  addTask(newTask);
                  _titleController.clear();
                  Navigator.pop(context);
                }),
                child: const Text('ADD')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasker"),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text("No tasks yet"),
            )
          : TaskList(_tasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
