import 'package:daytask/app/custom_button.dart';
import 'package:daytask/services/auth_provider.dart';
import 'package:daytask/services/navigation_provider.dart';
import 'package:daytask/services/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDayIndex = DateTime.now().weekday - 1;

  final TextEditingController titleConTroller = TextEditingController();
  final TextEditingController descriptionConTroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleConTroller.dispose();
    descriptionConTroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysOfWeek = List.generate(7, (index) {
      final day = today.subtract(Duration(days: today.weekday - 1 - index));
      return {
        'day': DateFormat.E().format(day),
        'date': DateFormat.d().format(day),
      };
    });
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await auth.logout();
              context.read<NavigationProvider>().navigateToLogin(context);
            },
            child: Icon(Icons.logout, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Week Days Selector
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: daysOfWeek.length,
                itemBuilder: (context, index) {
                  final day = daysOfWeek[index];
                  final isSelected = index == selectedDayIndex;
                  return GestureDetector(
                    onTap: () => setState(() => selectedDayIndex = index),
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Color(0xFF263238),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            day['date']!,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                          Text(
                            day['day']!,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Tasks",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 12),
            // Tasks List
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  final tasks = taskProvider.tasks;

                  if (tasks.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return GestureDetector(
                        onTap: () => showEditTaskBottomSheet(context, task),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            color:
                                task.isCompleted
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xFF263238),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      color:
                                          task.isCompleted
                                              ? Colors.black
                                              : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      color:
                                          task.isCompleted
                                              ? Colors.black
                                              : Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  task.isCompleted
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color:
                                      task.isCompleted
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                onPressed: () {
                                  Provider.of<TaskProvider>(
                                    context,
                                    listen: false,
                                  ).toggleTaskCompletion(task);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Color(0xFF263238),
            context: context,
            isScrollControlled: true,
            builder:
                (BuildContext context) => SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 15.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              'Create New Task',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Task Title',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: titleConTroller,
                            decoration: InputDecoration(hintText: '"e.g.- XYZ'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Description',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: descriptionConTroller,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Enter Description Here',
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            onTap: () {
                              final title = titleConTroller.text.trim();
                              final description =
                                  descriptionConTroller.text.trim();
                              if (title.isNotEmpty) {
                                Provider.of<TaskProvider>(
                                  context,
                                  listen: false,
                                ).addTask(title, description);
                                Navigator.pop(context);
                              }
                              titleConTroller.clear();
                              descriptionConTroller.clear();
                            },
                            text: 'Create',
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
          );
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Color(0xff263238)),
              Text('Add', style: TextStyle(color: Color(0xff263238))),
            ],
          ),
        ),
      ),
    );
  }

  void showEditTaskBottomSheet(BuildContext context, task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showModalBottomSheet(
      backgroundColor: const Color(0xFF263238),
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Edit Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final updatedTask = task.copyWith(
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                            );

                            Provider.of<TaskProvider>(
                              context,
                              listen: false,
                            ).updateTask(updatedTask);
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Provider.of<TaskProvider>(
                            context,
                            listen: false,
                          ).deleteTask(task.id);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
