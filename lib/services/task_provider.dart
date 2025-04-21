import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('id', ascending: false);

    _tasks = (response as List).map((e) => Task.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final response =
        await _client
            .from('tasks')
            .insert({
              'title': title,
              'description': description,
              'is_completed': false,
              'user_id': userId,
            })
            .select()
            .single();

    _tasks.insert(0, Task.fromMap(response));
    notifyListeners();
  }

  Future<void> toggleComplete(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isCompleted: !task.isCompleted,
      description: task.description,
    );

    await _client
        .from('tasks')
        .update({'is_completed': updatedTask.isCompleted})
        .eq('id', updatedTask.id);

    int index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
