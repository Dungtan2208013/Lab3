import 'package:flutter/material.dart';
import 'task_model.dart';
import 'task_provider.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskProvider _taskProvider = TaskProvider();
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    await _taskProvider.loadTasks();
    setState(() {});
  }

  void _addTask(String title) {
    setState(() {
      _taskProvider.tasks.add(Task(id: DateTime.now().toString(), title: title));
      _taskProvider.saveTasks();
    });
    _taskController.clear();
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      _taskProvider.saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'New Task'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _addTask(value);
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = _taskProvider.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      _toggleTaskCompletion(task);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}