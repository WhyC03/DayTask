import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Fetch user tasks
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

  // Add a new task
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

  // Toggle task completion
  Future<void> toggleTaskCompletion(Task task) async {
    // Update the local state immediately
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners(); // Notify listeners to update the UI
    }

    // Perform the database update in the background
    try {
      await _client
          .from('tasks')
          .update({'is_completed': _tasks[index].isCompleted})
          .eq('id', task.id);
    } catch (e) {
      // If the database update fails, revert the change
      _tasks[index] = task; // Revert to the original task
      notifyListeners();
      debugPrint('Error updating task completion: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    // taskId is now a String
    await _client.from('tasks').delete().eq('id', taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Update an existing task
  Future<void> updateTask(Task updatedTask) async {
    await _client
        .from('tasks')
        .update({
          'title': updatedTask.title,
          'description': updatedTask.description,
          'is_completed': updatedTask.isCompleted,
        })
        .eq('id', updatedTask.id);

    int index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
