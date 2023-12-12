import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  final String title;
  final String description;
  final Color color;

  Task({required this.title, required this.description, required this.color});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Tâches',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Tâches'),
        backgroundColor: Colors.cyanAccent,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return buildTaskItem(tasks[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );

          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyanAccent,
      ),
    );
  }

  Widget buildTaskItem(Task task) {
    return Dismissible(
      key: Key(task.hashCode.toString()),
      onDismissed: (direction) {
        setState(() {
          tasks.remove(task);
        });
      },
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
      ),
      child: Card(
        color: task.color,
        margin: EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              setState(() {
                tasks.remove(task);
              });
            },
          ),
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late Color randomColor;

  @override
  void initState() {
    super.initState();
    randomColor = getRandomColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Tâche'),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre :'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description :'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Task newTask = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  color: randomColor,
                );
                Navigator.pop(context, newTask);
              },
              child: Text('Ajouter Tâche'),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyanAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
