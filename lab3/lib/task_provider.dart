import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'task_model.dart';

class TaskProvider {
  List<Task> tasks = [];

  // Lấy đường dẫn thư mục ứng dụng
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/tasks.json';
  }

  // Lưu công việc vào file
  Future<void> saveTasks() async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    List<Map<String, dynamic>> jsonData = tasks.map((task) => task.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }

  // Đọc công việc từ file
  Future<void> loadTasks() async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (await file.exists()) {
      String content = await file.readAsString();
      List<dynamic> jsonData = json.decode(content);
      tasks = jsonData.map((task) => Task.fromJson(task)).toList();
    }
  }
}
